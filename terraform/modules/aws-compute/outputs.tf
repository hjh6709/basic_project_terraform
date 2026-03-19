output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.standby.id
}

# 승민님 → Cloudflare Origin Pool 등록
# 성호님 → GCP Cloud SQL Authorized Network 등록
output "elastic_ip" {
  description = "Elastic IP of standby EC2"
  value       = aws_eip.standby.public_ip
}

output "ssh_command" {
  description = "SSH 접속 명령어"
  value       = "ssh -i ~/.ssh/<your-key>.pem ubuntu@${aws_eip.standby.public_ip}"
}
