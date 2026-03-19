# -----------------------------------
# Ubuntu 22.04 LTS AMI (동적 조회)
# -----------------------------------
data "aws_ssm_parameter" "ubuntu_2204" {
  name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

# -----------------------------------
# Bastion Host Security Group
# -----------------------------------
# 운영자가 Bastion을 통해 Private Subnet의 Monitoring Server에 접근
# 이 SG ID를 희정님한테 전달 → Monitoring Server SG의 ingress에 등록
resource "aws_security_group" "bastion" {
  name        = "${var.project_name}-${var.environment}-bastion-sg"
  description = "Security group for Bastion Host"
  vpc_id      = var.vpc_id

  # SSH - 운영자 IP만 허용
  ingress {
    description = "SSH from operator"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # 아웃바운드 전체 허용
  # Bastion → Monitoring Server (Private Subnet) SSH 접근 필요
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-bastion-sg"
    Project     = var.project_name
    Environment = var.environment
    Role        = "bastion"
  }
}

# -----------------------------------
# Bastion Host EC2
# -----------------------------------
# Public Subnet에 배치
# 운영자 → Bastion → Monitoring Server (Private) 경로
resource "aws_instance" "bastion" {
  ami                         = data.aws_ssm_parameter.ubuntu_2204.value
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    delete_on_termination = true

    tags = {
      Name        = "${var.project_name}-${var.environment}-bastion-vol"
      Project     = var.project_name
      Environment = var.environment
    }
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-bastion"
    Project     = var.project_name
    Environment = var.environment
    Role        = "bastion"
  }
}

# -----------------------------------
# Bastion Elastic IP
# -----------------------------------
# 고정 IP로 운영자가 항상 같은 주소로 접속 가능
resource "aws_eip" "bastion" {
  domain     = "vpc"
  depends_on = [aws_instance.bastion]

  tags = {
    Name        = "${var.project_name}-${var.environment}-bastion-eip"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_eip_association" "bastion" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion.id
}
