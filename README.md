# basic_project_terraform — AWS Standby 최종 구조

## 파일 구조

```
.
├── .github/
│   └── workflows/
│       ├── terraform-aws-standby.yml
│       ├── ansible-aws-standby.yml
│       └── terraform-aws-destroy.yml
├── terraform/
│   ├── environments/
│   │   └── aws-standby/
│   │       ├── versions.tf
│   │       ├── provider.tf
│   │       ├── variables.tf
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       └── terraform.tfvars.example
│   └── modules/
│       ├── aws-network/      # VPC / Subnet / IGW / RT
│       ├── aws-security/     # k3s 노드 SG
│       ├── aws-compute/      # k3s 노드 EC2 + EIP
│       └── aws-bastion/      # Bastion EC2 + SG + EIP
└── ansible/
    ├── ansible.cfg
    ├── playbook.yml
    └── roles/
        ├── k3s/              # k3s 설치 + kubeconfig
        ├── node-exporter/    # Prometheus 메트릭 :9100
        └── cloudflared/      # Cloudflare Tunnel (token 받으면 활성화)
```

## AWS 인프라 구조

```
VPC (10.20.0.0/16)
├── Public Subnet (10.20.1.0/24)
│   ├── k3s 노드 (Standby App)    ← aws-compute
│   └── Bastion Host              ← aws-bastion
│
└── Private Subnet (10.20.2.0/24)
    └── Monitoring Server          ← 희정님 담당
        ├── Prometheus
        ├── Grafana
        └── Alertmanager
```

## 팀원별 전달값

Terraform 완료 후 Actions Summary에서 확인:

| 전달 대상 | 값 | 용도 |
|---|---|---|
| 승민님 | k3s 노드 EIP | Cloudflare Origin Pool 등록 |
| 성호님 | k3s 노드 EIP | GCP Cloud SQL Authorized Network 등록 |
| 희정님 | bastion_sg_id | Monitoring Server SG ingress에 등록 |
| 희정님 | vpc_id | Monitoring Server 배치 VPC |
| 희정님 | private_subnet_id | Monitoring Server 배치 Subnet |

## GitHub Secrets 필요 목록

| Secret | 내용 |
|---|---|
| AWS_ACCESS_KEY_ID | AWS 액세스 키 |
| AWS_SECRET_ACCESS_KEY | AWS 시크릿 키 |
| MY_IP | 본인 공인 IP (예: 14.51.98.44/32) |
| KEY_NAME | AWS Key Pair 이름 |
| SSH_PRIVATE_KEY | .pem 파일 내용 전체 |
| CF_TUNNEL_TOKEN | Cloudflare Tunnel 토큰 (승민님 받은 후 추가) |

## 로컬 실행

```bash
cd terraform/environments/aws-standby
cp terraform.tfvars.example terraform.tfvars
# 값 수정 후:
terraform init
terraform plan
terraform apply
```

## 현재 배포된 리소스 (feature/aws-security 완료)

```
vpc_id                    = vpc-0f47503a64df96212
public_subnet_id          = subnet-07bd30d9553b01ea9
private_subnet_id         = subnet-06f264ddc9f312b98
internet_gateway_id       = igw-06be434b4f31510c4
public_route_table_id     = rtb-0241ebdfd5683b077
standby_security_group_id = sg-00eb98fe77e1a6f39
```

## 다음 할 일

- [ ] GitHub Secrets 5개 등록
- [ ] main 브랜치에 push → Terraform 자동 실행
- [ ] Actions Summary에서 출력값 확인 후 팀원 전달
  - 승민님: k3s 노드 EIP
  - 성호님: k3s 노드 EIP
  - 희정님: bastion_sg_id / vpc_id / private_subnet_id
- [ ] 승민님한테 CF_TUNNEL_TOKEN 받아서 Secrets 추가
- [ ] Ansible에서 cloudflared --skip-tags 제거 후 재실행
