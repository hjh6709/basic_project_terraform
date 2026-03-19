# AWS Standby Infrastructure

## 역할

멀티 클라우드 Active-Standby 구조에서 **AWS Standby 환경**을 담당한다.

GCP Primary 장애 발생 시 Cloudflare Load Balancer가 Health Check 실패를 감지하고,
AWS Standby로 트래픽을 자동 전환한다.

```
사용자
  ↓
Cloudflare Load Balancer
  ├── GCP Primary (정상 시)
  └── AWS Standby (장애 시 Failover)  ← 여기
```

---

## 파일 구조

```
aws/
├── terraform/
│   ├── main.tf                   # Terraform backend + versions
│   ├── provider.tf               # AWS provider
│   ├── network.tf                # VPC / Subnet / IGW / Route Table
│   ├── security_group.tf         # Bastion SG / k3s 노드 SG
│   ├── ec2.tf                    # Bastion + k3s 노드 EC2
│   ├── outputs.tf                # 팀원 전달값 출력
│   ├── variables.tf              # 변수 정의
│   └── terraform.tfvars.example  # 로컬 실행용 템플릿
└── ansible/
    ├── ansible.cfg
    ├── playbook.yml
    └── roles/
        ├── k3s/                  # k3s 설치 + kubeconfig
        ├── node-exporter/        # Prometheus 메트릭 수집 (:9100)
        └── cloudflared/          # Cloudflare Tunnel 배포
```

---

## AWS 인프라 구조

```
VPC (10.20.0.0/16)
├── Public Subnet (10.20.1.0/24)
│   ├── k3s 노드 (Standby App)
│   └── Bastion Host
│
└── Private Subnet (10.20.2.0/24)
    └── Monitoring Server (희정님 담당)
```

### Cloudflare Tunnel 방식

k3s 노드는 인바운드 포트(80/443)를 열지 않는다.
EC2 내부의 `cloudflared`가 Cloudflare로 아웃바운드 연결을 먼저 맺고,
Cloudflare가 그 터널을 통해 트래픽을 전달하는 방식이다.

```
사용자 → Cloudflare → Tunnel → cloudflared → k3s 앱
                        ↑
             EC2가 먼저 연결을 맺어놓음 (아웃바운드)
```

---

## 팀원 전달값

`terraform apply` 완료 후 GitHub Actions Summary 또는 `terraform output`에서 확인

| 출력값 | 전달 대상 | 용도 |
|---|---|---|
| `bastion_sg_id` | 희정님 | Monitoring Server SG ingress 등록 |
| `vpc_id` | 희정님 | Monitoring Server 배치 VPC |
| `private_subnet_id` | 희정님 | Monitoring Server 배치 Subnet |
| `k3s_public_ip` | 승민님 | Cloudflare Tunnel 연결 확인 |

---

## 실행 방법

### 로컬 실행

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# terraform.tfvars 열어서 값 수정

terraform init
terraform plan
terraform apply
```

### GitHub Actions 자동 실행

`main` 브랜치에 push하면 자동 실행된다.

```
push → Terraform workflow → EC2 생성
                ↓
       Ansible workflow → k3s / node-exporter / cloudflared 설치
```

---

## GitHub Secrets 목록

| Secret | 내용 |
|---|---|
| `AWS_ACCESS_KEY_ID` | AWS 액세스 키 |
| `AWS_SECRET_ACCESS_KEY` | AWS 시크릿 키 |
| `MY_IP` | 운영자 공인 IP (예: 1.2.3.4/32) |
| `KEY_NAME` | AWS Key Pair 이름 |
| `SSH_PRIVATE_KEY` | .pem 파일 내용 전체 |
| `CF_TUNNEL_TOKEN` | Cloudflare Tunnel 토큰 (승민님 전달) |

---

## 작업 순서

| 단계 | 내용 | 상태 |
|---|---|---|
| 1 | VPC / Subnet / IGW / Route Table | 완료 |
| 2 | Security Group (Bastion / k3s) | 완료 |
| 3 | EC2 (Bastion / k3s 노드) | 완료 |
| 4 | k3s 설치 + Node Exporter | 완료 |
| 5 | Cloudflare Tunnel 연결 | 승민님 token 대기 중 |
| 6 | 앱 배포 (호성님 연동) | 예정 |
| 7 | Failover 테스트 | 예정 |