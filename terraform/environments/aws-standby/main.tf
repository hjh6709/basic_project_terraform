module "network" {
  source = "../../modules/aws-network"

  name_prefix = local.name_prefix
  vpc_cidr    = local.vpc_cidr
  subnet_cidr = local.subnet_cidr
  az          = local.az
  common_tags = local.common_tags
}

module "compute" {
  source = "../../modules/aws-compute"

  name_prefix      = local.name_prefix
  instance_type    = local.instance_type
  root_volume_size = local.root_volume_size
  subnet_id        = module.network.public_subnet_id
  vpc_id           = module.network.vpc_id
  my_ip            = var.my_ip
  key_name         = var.key_name
  common_tags      = local.common_tags
}