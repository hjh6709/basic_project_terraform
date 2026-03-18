# aws-network 모듈 호출
# 여기서 실제 값들을 넘겨서 VPC / Subnet / Route를 생성
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
# 생성된 VPC 안에 standby EC2용 보안그룹 생성
module "aws_security" {
  source = "../../modules/aws-security"

  project_name     = var.project_name
  environment      = var.environment
  vpc_id           = module.aws_network.vpc_id
  vpc_cidr         = var.vpc_cidr
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

module "aws_compute" {
  source = "../../modules/aws-compute"

  project_name                = var.project_name
  environment                 = var.environment
  subnet_id                   = module.aws_network.public_subnet_id
  security_group_ids          = [module.aws_security.standby_security_group_id]
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
}