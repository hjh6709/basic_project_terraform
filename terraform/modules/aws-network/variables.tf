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

# VPC CIDR
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

# Public Subnet CIDR
variable "public_subnet_cidr" {
  description = "Public subnet CIDR block"
  type        = string
}

# Private Subnet CIDR
variable "private_subnet_cidr" {
  description = "Private subnet CIDR block"
  type        = string
}

# 리소스를 배치할 AZ
variable "availability_zone" {
  description = "Availability zone"
  type        = string
}