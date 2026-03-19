# 희정님한테 전달 → Monitoring Server SG ingress에 등록
output "bastion_sg_id" {
  description = "Bastion Security Group ID → 희정님 Monitoring Server SG에 등록"
  value       = aws_security_group.bastion.id
}

output "bastion_eip" {
  description = "Bastion Host Public IP"
  value       = aws_eip.bastion.public_ip
}

output "bastion_ssh_command" {
  description = "Bastion SSH 접속 명령어"
  value       = "ssh -i ~/.ssh/<your-key>.pem ubuntu@${aws_eip.bastion.public_ip}"
}
