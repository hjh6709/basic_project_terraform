variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

# feature/aws-security에서 만든 public_subnet_id
variable "subnet_id" {
  description = "Subnet ID where EC2 will be placed"
  type        = string
}

# feature/aws-security에서 만든 standby_security_group_id
variable "security_group_id" {
  description = "Security Group ID to attach to EC2"
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
