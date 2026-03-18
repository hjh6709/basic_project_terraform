# AWS 리전
variable "aws_region" {
  description = "AWS region"
  type        = string
}

# 프로젝트 이름
# 예: hybrid-ha
variable "project_name" {
  description = "Project name"
  type        = string
}

# 환경 이름
# 예: aws-standby
variable "environment" {
  description = "Environment name"
  type        = string
}

# VPC 전체 CIDR 대역
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

# Public Subnet CIDR 대역
variable "public_subnet_cidr" {
  description = "Public subnet CIDR block"
  type        = string
}

# Private Subnet CIDR 대역
variable "private_subnet_cidr" {
  description = "Private subnet CIDR block"
  type        = string
}

# 리소스를 생성할 가용영역
# 예: ap-northeast-2a
variable "availability_zone" {
  description = "Availability zone"
  type        = string
}

# SSH 허용 CIDR
# 예: "1.2.3.4/32"
variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to access SSH"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}