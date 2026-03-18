# 최종적으로 environment 단에서 VPC ID 출력
output "vpc_id" {
  description = "VPC ID"
  value       = module.aws_network.vpc_id
}

# 최종적으로 environment 단에서 Public Subnet ID 출력
output "public_subnet_id" {
  description = "Public subnet ID"
  value       = module.aws_network.public_subnet_id
}

# 최종적으로 environment 단에서 Private Subnet ID 출력
output "private_subnet_id" {
  description = "Private subnet ID"
  value       = module.aws_network.private_subnet_id
}

# Internet Gateway ID 출력
output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.aws_network.internet_gateway_id
}

# Public Route Table ID 출력
output "public_route_table_id" {
  description = "Public route table ID"
  value       = module.aws_network.public_route_table_id
}