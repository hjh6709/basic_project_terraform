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

# EC2를 띄울 subnet ID
variable "subnet_id" {
  description = "Subnet ID for EC2"
  type        = string
}

# EC2에 부착할 Security Group ID 목록
variable "security_group_ids" {
  description = "Security Group IDs for EC2"
  type        = list(string)
}

# EC2 타입
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

# AWS key pair 이름
variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

# Public IP 자동 할당 여부
variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address"
  type        = bool
  default     = true
}