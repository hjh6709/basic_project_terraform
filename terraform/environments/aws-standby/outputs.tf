# 승민님한테 전달 → Cloudflare Failover Origin Pool 등록
output "ec2_elastic_ip" {
  description = "AWS Standby EC2 Elastic IP → 승민님 Cloudflare Origin Pool에 등록"
  value       = module.compute.ec2_elastic_ip
}

# 성호님한테 전달 → GCP Cloud SQL Authorized Network 등록
output "nat_gateway_ip" {
  description = "NAT Gateway Public IP → 성호님 GCP Cloud SQL Authorized Network에 등록"
  value       = module.network.nat_gateway_ip
}

output "instance_id" {
  description = "EC2 Instance ID"
  value       = module.compute.instance_id
}

output "ssh_command" {
  description = "EC2 SSH 접속 명령어"
  value       = "ssh -i ~/.ssh/chilseong-jh.pem ubuntu@${module.compute.ec2_elastic_ip}"
}

output "security_group_id" {
  description = "Security Group ID"
  value       = module.compute.security_group_id
}