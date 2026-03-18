# -----------------------------------
# AWS Standby EC2용 Security Group
# -----------------------------------
# 이후 EC2 인스턴스에 부착할 기본 보안그룹
resource "aws_security_group" "standby" {
  name        = "${var.project_name}-${var.environment}-standby-sg"
  description = "Security group for AWS standby EC2"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.project_name}-${var.environment}-standby-sg"
    Project     = var.project_name
    Environment = var.environment
  }
}

# -----------------------------------
# SSH Ingress Rule
# -----------------------------------
# 정현님 또는 운영자가 SSH로 EC2에 접속할 수 있도록 허용
# 실습 단계에서는 본인 공인 IP만 허용하는 것이 가장 안전
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.standby.id
  cidr_ipv4         = var.allowed_ssh_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = {
    Name = "${var.project_name}-${var.environment}-allow-ssh"
  }
}

# -----------------------------------
# 내부 VPC 통신 허용
# -----------------------------------
# 같은 VPC 내부에서 들어오는 트래픽은 허용
# 이후 private/public subnet 간 내부 통신, 내부 서비스 접근 등에 사용 가능
resource "aws_vpc_security_group_ingress_rule" "internal" {
  security_group_id = aws_security_group.standby.id
  cidr_ipv4         = var.vpc_cidr
  from_port         = 0
  ip_protocol       = "-1" # 모든 프로토콜
  to_port           = 0

  tags = {
    Name = "${var.project_name}-${var.environment}-allow-internal"
  }
}

# -----------------------------------
# 전체 아웃바운드 허용
# -----------------------------------
# EC2가 외부로 나가는 트래픽 허용
# apt 설치, 패키지 다운로드, k3s 설치, 이미지 pull 등에 필요
resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.standby.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # 모든 프로토콜

  tags = {
    Name = "${var.project_name}-${var.environment}-allow-all-egress"
  }
}