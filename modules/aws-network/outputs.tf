output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "퍼블릭 서브넷 ID"
  value       = aws_subnet.public.id
}

output "nat_gateway_ip" {
  description = "NAT Gateway Public IP → 성호님 Cloud SQL Authorized Network 등록용"
  value       = aws_eip.nat.public_ip
}