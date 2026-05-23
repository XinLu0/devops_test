# DevOps Take-Home Test

This repository contains the solution for both parts of the DevOps take-home assessment.

## Repository Structure

```
/
├── .github/
│   └── workflows/
│       └── deploy.yml              # GitHub Actions CI/CD pipeline
├── task1/                          # Part 1: Architecture design proposal
│   ├── architecture_diagram.png    # AWS architecture diagram
│   ├── design_proposal.pdf         # PDF version with architecture diagram
│
├── task2/                          # Part 2: Implementation Challenge
│   ├── app/                        # Simple Python (Flask) web server
│   │   ├── app.py
│   │   ├── Dockerfile
│   │   └── requirements.txt
│   └── terraform/                  # Terraform infrastructure (modularised)
│       ├── main.tf                 # Provider & backend configuration
│       ├── variables.tf            # Input variables
│       ├── outputs.tf              # Stack outputs
│       ├── modules.tf              # Module wiring
│       └── modules/
│           ├── ecr/                # ECR repository with scanning & lifecycle
│           ├── ecs/                # ECS Fargate + ALB + CloudWatch Logs
│           ├── monitoring/         # CloudWatch alarms (CPU, memory, unhealthy hosts)
│           ├── vpc/                # VPC with public subnets & flow logs
│           └── waf/                # AWS WAF Web ACL (OWASP rules, rate limiting)
│
└── README.md                       # This file
```

---

## Part 1: Design Challenge

A PDF version is available at [task1/design_proposal.pdf](task1/design_proposal.pdf).

---

## Part 2: Implementation Challenge

### Prerequisites

| Tool | Version |
|------|---------|
| Terraform | >= 1.5 |
| AWS CLI | >= 2 |
| Docker | >= 24 |

You must have valid AWS credentials configured (`aws configure` or environment variables).

### Quick Start

#### 1. Initialise Terraform (first time only)

```bash
cd task2/terraform
terraform init
```

#### 2. Build & push the Docker image manually (first time)

```bash
# Deploy ECR first
cd task2/terraform
terraform apply -target=module.ecr -auto-approve

# Login to ECR
aws ecr get-login-password --region ap-southeast-2 | \
  docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.ap-southeast-2.amazonaws.com

# Build and push
cd ../app
docker build -t devops-test-app .
docker tag devops-test-app:latest <ACCOUNT_ID>.dkr.ecr.ap-southeast-2.amazonaws.com/devops-test-app:latest
docker push <ACCOUNT_ID>.dkr.ecr.ap-southeast-2.amazonaws.com/devops-test-app:latest
```

#### 3. Deploy all infrastructure

```bash
cd task2/terraform
terraform apply -auto-approve
```

#### 4. Access the application

After deployment, Terraform prints the ALB DNS name:

```
Outputs:
alb_dns_name = "devops-test-alb-xxxx.ap-southeast-2.elb.amazonaws.com"
```

Open that URL in your browser to see the "Hello World" page.

---

### CI/CD (GitHub Actions)

The pipeline at `.github/workflows/deploy.yml` automates the full flow:

1. **Build** — builds the Docker image and pushes to ECR (tagged with the Git SHA).
2. **Deploy Infra** — runs `terraform apply` to create/update all resources.
3. **Deploy Service** — forces a new ECS deployment and waits for stability.

Note: For the first deployment, create the ECR repository before running the full GitHub Actions pipeline:

```bash
cd task2/terraform
terraform init
terraform apply -target=module.ecr -auto-approve
```

After the ECR repository exists, the GitHub Actions pipeline can build, push, and deploy the application automatically.

### Required GitHub Secrets

| Secret | Description |
|--------|-------------|
| `AWS_ROLE_ARN` | ARN of the IAM role the workflow assumes via OIDC |

### Setting up OIDC

Follow the [GitHub guide](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) to create an IAM OIDC identity provider and a role that GitHub Actions can assume.

---

## Cleanup

```bash
cd task2/terraform
terraform destroy -auto-approve
```

