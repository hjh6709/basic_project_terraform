# basic_project_terraform -> feature/aws-security

## 파일 구조
```
terraform/
 ├ environments/
 │   └ aws-standby/
 │       ├ provider.tf
 │       ├ versions.tf
 │       ├ variables.tf
 │       ├ terraform.tfvars
 │       ├ main.tf
 │       └ outputs.tf
 └ modules/
     ├ aws-network/
     │   ├ main.tf
     │   ├ variables.tf
     │   └ outputs.tf
     └ aws-security/
         ├ main.tf
         ├ variables.tf
         └ outputs.tf
```
