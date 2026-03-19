# aws-network 모듈 호출
module "aws_network" {
  source = "../../modules/aws-network"

  project_name        = var.project_name
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
}

# aws-security 모듈 호출
# network 완료 후 VPC ID 받아서 SG 생성
module "aws_security" {
  source = "../../modules/aws-security"

  project_name     = var.project_name
  environment      = var.environment
  vpc_id           = module.aws_network.vpc_id
  vpc_cidr         = var.vpc_cidr
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

# aws-compute 모듈 호출
# network / security 완료 후 EC2 + EIP 생성
module "aws_compute" {
  source = "../../modules/aws-compute"

  project_name      = var.project_name
  environment       = var.environment
  subnet_id         = module.aws_network.public_subnet_id
  security_group_id = module.aws_security.standby_security_group_id
  instance_type     = var.instance_type
  root_volume_size  = var.root_volume_size
  key_name          = var.key_name
}

# aws-bastion 모듈 호출
# Public Subnet에 Bastion Host 생성
# bastion_sg_id → 희정님 Monitoring Server SG에 등록
module "aws_bastion" {
  source = "../../modules/aws-bastion"

  project_name     = var.project_name
  environment      = var.environment
  subnet_id        = module.aws_network.public_subnet_id
  vpc_id           = module.aws_network.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
  key_name         = var.key_name
  instance_type    = var.bastion_instance_type
}
