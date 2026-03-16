variable "name_prefix" {
  description = "리소스 이름 prefix"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR 대역"
  type        = string
}

variable "subnet_cidr" {
  description = "퍼블릭 서브넷 CIDR 대역"
  type        = string
}

variable "az" {
  description = "가용 영역"
  type        = string
}

variable "common_tags" {
  description = "모든 리소스에 공통으로 붙는 태그"
  type        = map(string)
}