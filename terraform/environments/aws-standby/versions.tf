terraform {
  # 사용 가능한 Terraform 최소 버전
  required_version = ">= 1.5.0"

  # 이 프로젝트에서 사용할 Provider와 버전 지정
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}