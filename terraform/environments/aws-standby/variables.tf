variable "project_name" {
  description = "프로젝트 이름"
  type        = string
  default     = "hybrid-project"
}

variable "environment" {
  description = "배포 환경"
  type        = string
  default     = "dev"
}

variable "my_ip" {
  description = "SSH 접속을 허용할 운영자 IP (CIDR 형식 예: x.x.x.x/32)"
  type        = string
}

variable "key_name" {
  description = "AWS 콘솔에서 미리 만들어둔 키페어 이름"
  type        = string
}