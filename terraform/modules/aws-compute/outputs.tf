output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.standby.id
}

# Public IP (자동 할당 - 재시작 시 변경될 수 있음)
# Tunnel 방식이라 고정 IP 불필요
output "public_ip" {
  description = "EC2 Public IP (자동 할당)"
  value       = aws_instance.standby.public_ip
}

output "ssh_command" {
  description = "SSH 접속 명령어"
  value       = "ssh -i ~/.ssh/<your-key>.pem ubuntu@${aws_instance.standby.public_ip}"
}
