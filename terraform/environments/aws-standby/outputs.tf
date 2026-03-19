# 네트워크 outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.aws_network.vpc_id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = module.aws_network.public_subnet_id
}

output "private_subnet_id" {
  description = "Private subnet ID"
  value       = module.aws_network.private_subnet_id
}

# 보안 outputs
output "standby_security_group_id" {
  description = "Security Group ID"
  value       = module.aws_security.standby_security_group_id
}

# 컴퓨트 outputs
output "instance_id" {
  description = "EC2 Instance ID"
  value       = module.aws_compute.instance_id
}

# 승민님 → Cloudflare Origin Pool 등록
# 성호님 → GCP Cloud SQL Authorized Network 등록
output "elastic_ip" {
  description = "EC2 Elastic IP"
  value       = module.aws_compute.elastic_ip
}

output "ssh_command" {
  description = "SSH 접속 명령어"
  value       = module.aws_compute.ssh_command
}

# Bastion outputs
# 희정님한테 전달 → Monitoring Server SG ingress에 등록
output "bastion_sg_id" {
  description = "Bastion SG ID → 희정님 Monitoring Server SG에 등록"
  value       = module.aws_bastion.bastion_sg_id
}

output "bastion_eip" {
  description = "Bastion Host Public IP"
  value       = module.aws_bastion.bastion_eip
}

output "bastion_ssh_command" {
  description = "Bastion SSH 접속 명령어"
  value       = module.aws_bastion.bastion_ssh_command
}
