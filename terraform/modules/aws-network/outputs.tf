# 생성된 VPC ID 출력
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

# 생성된 Public Subnet ID 출력
output "public_subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public.id
}

# 생성된 Private Subnet ID 출력
output "private_subnet_id" {
  description = "Private subnet ID"
  value       = aws_subnet.private.id
}

# 생성된 Internet Gateway ID 출력
output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.this.id
}

# 생성된 Public Route Table ID 출력
output "public_route_table_id" {
  description = "Public route table ID"
  value       = aws_route_table.public.id
}