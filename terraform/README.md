# AWS Standby Infrastructure

## 파일 구조

```
terraform/
├── main.tf              # Terraform backend + versions
├── provider.tf          # AWS provider
├── network.tf           # VPC / Subnet / IGW / Route Table
├── security_group.tf    # Bastion SG / k3s 노드 SG
├── ec2.tf               # Bastion + k3s 노드 EC2
├── outputs.tf           # 팀원 전달값 출력
├── variables.tf         # 변수 정의
└── terraform.tfvars.example
```

## AWS 인프라 구조

```
VPC (10.20.0.0/16)
├── Public Subnet (10.20.1.0/24)
│   ├── k3s 노드 (Standby App)
│   └── Bastion Host
└── Private Subnet (10.20.2.0/24)
    └── Monitoring Server (희정님 담당)
```

## 팀원 전달값

terraform apply 후 outputs에서 확인:

| 항목 | 전달 대상 | 용도 |
|---|---|---|
| bastion_sg_id | 희정님 | Monitoring Server SG ingress 등록 |
| private_subnet_id | 희정님 | Monitoring Server 배치 위치 |
| vpc_id | 희정님 | Monitoring Server VPC |
| k3s_public_ip | 승민님 | Cloudflare Tunnel 연결 확인 |

## 로컬 실행

```bash
cp terraform.tfvars.example terraform.tfvars
# 값 수정 후:
terraform init
terraform plan
terraform apply
```
