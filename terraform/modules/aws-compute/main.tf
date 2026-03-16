# -----------------------------------------------
# Ubuntu 22.04 LTS AMI
# SSM Parameter Store - latest AMI ID
# -----------------------------------------------
data "aws_ssm_parameter" "ubuntu_2204" {
  name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

# -----------------------------------------------
# Security Group
# -----------------------------------------------
resource "aws_security_group" "k3s" {
  name        = "${var.name_prefix}-k3s-sg"
  description = "k3s single node security group"
  vpc_id      = var.vpc_id

  # SSH - operator only
  ingress {
    description = "SSH from operator"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # HTTP - Cloudflare traffic
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS - Cloudflare traffic
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Kubernetes API Server
  # Headlamp + kubectl deploy
  ingress {
    description = "Kubernetes API Server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # App /metrics + /health
  # Prometheus Scrape + Cloudflare Health Check
  ingress {
    description = "App metrics and health check"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Node Exporter
  # Prometheus infrastructure metrics
  ingress {
    description = "Node Exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Internal node communication (k3s components)
  ingress {
    description = "All traffic within same security group"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  # Allow all outbound
  # GCP Cloud SQL access, DockerHub pull, etc
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
# EC2 Instance (k3s single node)
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
# Fixed IP even after restart
# Send this IP to Cloudflare Failover Origin
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