# -----------------------------------
# Ubuntu 22.04 LTS AMI
# SSM Parameter Store에서 동적으로 최신 AMI ID 조회
# 하드코딩 없이 항상 최신 Ubuntu 22.04 사용
# -----------------------------------
data "aws_ssm_parameter" "ubuntu_2204" {
  name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

# -----------------------------------
# EC2 Instance (k3s single node)
# -----------------------------------
# AWS Standby 핵심 서버
# 이 위에 k3s / cloudflared / node-exporter 올라감
resource "aws_instance" "standby" {
  ami                         = data.aws_ssm_parameter.ubuntu_2204.value
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    delete_on_termination = true

    tags = {
      Name        = "${var.project_name}-${var.environment}-root-vol"
      Project     = var.project_name
      Environment = var.environment
    }
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-k3s-node"
    Project     = var.project_name
    Environment = var.environment
    Role        = "standby"
  }
}

# -----------------------------------
# Elastic IP
# -----------------------------------
# EC2 재시작해도 IP 고정
# 이 IP를 승민님 → Cloudflare Origin Pool 등록
# 이 IP를 성호님 → GCP Cloud SQL Authorized Network 등록
resource "aws_eip" "standby" {
  domain     = "vpc"
  depends_on = [aws_instance.standby]

  tags = {
    Name        = "${var.project_name}-${var.environment}-eip"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_eip_association" "standby" {
  instance_id   = aws_instance.standby.id
  allocation_id = aws_eip.standby.id
}
