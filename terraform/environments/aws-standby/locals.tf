locals {
  region           = "ap-northeast-2"
  az               = "ap-northeast-2a"
  vpc_cidr         = "10.20.0.0/16"
  subnet_cidr      = "10.20.1.0/24"
  instance_type    = "t3.small"
  root_volume_size = 20

  name_prefix = "${var.project_name}-${var.environment}-aws-standby"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Role        = "standby"
    Region      = "ap-northeast-2"
  }
}