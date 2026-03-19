variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

# Public Subnet에 Bastion 배치
# 정현님 aws-network 모듈의 public_subnet_id
variable "subnet_id" {
  description = "Public subnet ID for Bastion Host"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

# SSH 허용 CIDR - 운영자 IP만
variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into Bastion"
  type        = string
}

variable "key_name" {
  description = "AWS Key Pair name"
  type        = string
}

variable "instance_type" {
  description = "Bastion EC2 instance type"
  type        = string
  default     = "t3.micro"
}
