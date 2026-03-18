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