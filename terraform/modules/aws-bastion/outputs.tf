# 희정님한테 전달 → Monitoring Server SG ingress에 등록
output "bastion_sg_id" {
  description = "Bastion Security Group ID → 희정님 Monitoring Server SG에 등록"
  value       = aws_security_group.bastion.id
}

# Public IP (자동 할당)
output "bastion_public_ip" {
  description = "Bastion Host Public IP (자동 할당)"
  value       = aws_instance.bastion.public_ip
}

output "bastion_ssh_command" {
  description = "Bastion SSH 접속 명령어"
  value       = "ssh -i ~/.ssh/<your-key>.pem ubuntu@${aws_instance.bastion.public_ip}"
}
