# 프로젝트 이름
variable "project_name" {
  description = "Project name"
  type        = string
}

# 환경 이름
variable "environment" {
  description = "Environment name"
  type        = string
}

# VPC ID
# Security Group은 어느 VPC 안에 생성할지 알아야 하므로 필요
variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

# VPC CIDR
# 내부 통신 허용 규칙에 사용
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

# SSH 접속 허용 CIDR
# 초기에는 내 IP만 넣는 것을 권장
variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to access SSH"
  type        = string
}