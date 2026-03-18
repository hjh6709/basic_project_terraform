# -----------------------------------
# VPC 생성
# -----------------------------------
# AWS standby 환경 전체를 감싸는 네트워크 영역
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Project     = var.project_name
    Environment = var.environment
  }
}

# -----------------------------------
# Internet Gateway 생성
# -----------------------------------
# Public Subnet이 인터넷과 통신할 수 있도록 연결하는 게이트웨이
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-igw"
    Project     = var.project_name
    Environment = var.environment
  }
}

# -----------------------------------
# Public Subnet 생성
# -----------------------------------
# 추후 Bastion, NAT Gateway 또는 외부 노출이 필요한 리소스가 들어갈 수 있는 서브넷
# map_public_ip_on_launch = true
# -> 이 Subnet에 생성되는 EC2가 자동으로 Public IP를 받을 수 있게 설정
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-subnet"
    Project     = var.project_name
    Environment = var.environment
    Tier        = "public"
  }
}

# -----------------------------------
# Private Subnet 생성
# -----------------------------------
# 실제 standby app 또는 k3s node를 넣을 수 있는 내부용 서브넷
# map_public_ip_on_launch = false
# -> 자동 Public IP 부여 안 함
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-subnet"
    Project     = var.project_name
    Environment = var.environment
    Tier        = "private"
  }
}

# -----------------------------------
# Public Route Table 생성
# -----------------------------------
# Public Subnet이 어떤 라우팅 규칙을 사용할지 정의
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-rt"
    Project     = var.project_name
    Environment = var.environment
  }
}

# -----------------------------------
# Public Route 추가
# -----------------------------------
# 모든 외부 트래픽(0.0.0.0/0)을 Internet Gateway로 보냄
# 즉 Public Subnet은 인터넷과 통신 가능
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# -----------------------------------
# Public Subnet과 Route Table 연결
# -----------------------------------
# 방금 만든 Public Route Table을 Public Subnet에 연결
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}