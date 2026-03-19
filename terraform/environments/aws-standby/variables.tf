variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR block"
  type        = string
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR block"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
}

# SSH 허용 CIDR - 본인 공인 IP만
variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to access SSH"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 20
}

# AWS 콘솔에서 미리 만들어둔 Key Pair 이름
variable "key_name" {
  description = "AWS Key Pair name"
  type        = string
}

# Bastion 인스턴스 타입 (트래픽 적으므로 t3.micro로 충분)
variable "bastion_instance_type" {
  description = "Bastion Host EC2 instance type"
  type        = string
  default     = "t3.micro"
}
