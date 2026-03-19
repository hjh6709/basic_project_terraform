terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "hybrid-project-terraform-state"
    key            = "aws-standby/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "hybrid-project-terraform-lock"
    encrypt        = true
  }
}
