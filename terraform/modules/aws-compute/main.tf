# -----------------------------------------------
# Ubuntu 22.04 LTS AMI
# SSM Parameter Store에서 최신 AMI ID 자동 조회
# -----------------------------------------------
data "aws_ssm_parameter" "ubuntu_2204" {
  name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

# -----------------------------------------------
# 보안 그룹
# -----------------------------------------------
resource "aws_security_group" "k3s" {
  name        = "${var.name_prefix}-k3s-sg"
  description = "k3s 단일 노드 보안 그룹"
  vpc_id      = var.vpc_id

  # SSH - 운영자 IP만 허용
  ingress {
    description = "SSH from operator"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # HTTP - Cloudflare 트래픽
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS - Cloudflare 트래픽
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Kubernetes API Server
  # 희정님 Headlamp + 승민님 kubectl 배포
  ingress {
    description = "Kubernetes API Server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # App /metrics + /health
  # 희정님 Prometheus Scrape + Cloudflare Health Check
  ingress {
    description = "App metrics and health check"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Node Exporter
  # 희정님 Prometheus 인프라 메트릭 수집
  ingress {
    description = "Node Exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 노드 내부 통신 (k3s 컴포넌트 간)
  ingress {
    description = "All traffic within same security group"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  # 아웃바운드 전체 허용
  # GCP Cloud SQL 접근, DockerHub pull 등
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-k3s-sg"
  })
}

# -----------------------------------------------
# EC2 인스턴스 (k3s 단일 노드)
# Ubuntu 22.04 / t3.small / 20GB
# -----------------------------------------------
resource "aws_instance" "k3s" {
  ami                         = data.aws_ssm_parameter.ubuntu_2204.value
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.k3s.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    delete_on_termination = true

    tags = merge(var.common_tags, {
      Name = "${var.name_prefix}-root-volume"
    })
  }

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-k3s-node"
  })
}

# -----------------------------------------------
# EC2 Elastic IP
# 재시작해도 IP 고정
# 이 IP를 승민님한테 전달 → Cloudflare Failover Origin 등록
# -----------------------------------------------
resource "aws_eip" "ec2" {
  domain     = "vpc"
  depends_on = [aws_instance.k3s]

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-ec2-eip"
  })
}

resource "aws_eip_association" "ec2" {
  instance_id   = aws_instance.k3s.id
  allocation_id = aws_eip.ec2.id
}