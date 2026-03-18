# AWS Provider 설정
# var.aws_region 값에 따라 어느 리전에 리소스를 생성할지 결정
provider "aws" {
  region = var.aws_region
}