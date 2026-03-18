# 생성된 Standby Security Group ID 출력
output "standby_security_group_id" {
  description = "Security Group ID for standby EC2"
  value       = aws_security_group.standby.id
}