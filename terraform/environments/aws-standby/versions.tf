terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # S3 backend - 팀 공유 state 관리
  # 사전 조건: S3 버킷 + DynamoDB 테이블 생성 필요
  backend "s3" {
    bucket         = "hybrid-ha-terraform-state"
    key            = "aws-standby/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "hybrid-ha-terraform-lock"
    encrypt        = true
  }
}
