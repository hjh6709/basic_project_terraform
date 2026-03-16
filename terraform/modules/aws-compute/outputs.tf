output "ec2_elastic_ip" {
  description = "EC2 Elastic IP → 승민님 Cloudflare Failover Origin 등록용"
  value       = aws_eip.ec2.public_ip
}

output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.k3s.id
}

output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.k3s.id
}