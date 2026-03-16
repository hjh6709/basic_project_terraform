variable "name_prefix" {
  description = "리소스 이름 prefix"
  type        = string
}

variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
}

variable "root_volume_size" {
  description = "루트 볼륨 크기 (GB)"
  type        = number
}

variable "subnet_id" {
  description = "EC2를 배치할 퍼블릭 서브넷 ID"
  type        = string
}

variable "vpc_id" {
  description = "보안 그룹을 생성할 VPC ID"
  type        = string
}

variable "my_ip" {
  description = "SSH 접속을 허용할 운영자 IP (CIDR 형식)"
  type        = string
}

variable "key_name" {
  description = "AWS 콘솔에서 미리 만들어둔 키페어 이름"
  type        = string
}

variable "common_tags" {
  description = "모든 리소스에 공통으로 붙는 태그"
  type        = map(string)
}