# acs730-two-tier-apps-terraform-group4
# 📘 Two-Tier Web Application Automation with Terraform  
**ACS730 – Final Project**  
**Group Name:** Group4
**Environments:** Dev • Staging • Prod  

---

## 📌 1. Project Overview

This project automates the deployment of a high-availability, two-tier web application using **Terraform**, **AWS Auto Scaling**, **Application Load Balancer (ALB)**, **custom VPC networking**, and **S3-based static content**.

The solution includes:

- Fully automated Infrastructure-as-Code (IaC)
- Isolated Dev, Staging, and Prod environments
- Custom VPC with public/private subnets
- Auto Scaling Group (ASG)
- Application Load Balancer (ALB)
- EC2 IAM Role for S3 access
- S3 bucket hosting static assets (images)
- GitHub Actions security scanning (TFLint + Trivy)
- Remote backend using S3

---

## 🏗 2. Architecture Diagram

### High-Level Structure
```
VPC (10.x.0.0/16)
│
├── Public Subnets (ALB, NAT Gateway)
└── Private Subnets (Auto Scaling EC2 Web Tier)
```

Components:
- 3 Availability Zones  
- ALB in public subnets  
- Web tier in private subnets  
- S3 bucket for static objects  
- IAM role to allow EC2 → S3 access  
- NAT Gateway for outbound traffic  
- Terraform state stored in S3 backend  

---

## 🌐 3. Traffic Flows Explanation

### 🔹 Flow 1: End User → ALB → Private EC2
1. User enters the ALB DNS name in a browser.
2. ALB receives HTTP request on port 80.
3. ALB forwards traffic to the Target Group.
4. Target Group routes to a healthy EC2 instance.
5. Response returned to user.

### 🔹 Flow 2: EC2 → S3 Bucket
EC2 retrieves image during boot:
```
aws s3 cp s3://<bucket>/flower.jpg /var/www/html/
```

### 🔹 Flow 3: DevOps → GitHub → AWS
- Developer pushes changes
- GitHub Actions:
  - Runs **TFLint**
  - Runs **Trivy**
- After approval, Terraform deploys infrastructure

---

## 🗂 4. Repository Structure

```
acs730-final-project-group1/
├── modules/
│   ├── networking/
│   ├── alb/
│   ├── asg/
│   └── iam_s3/
└── envs/
    ├── dev/
    ├── staging/
    └── prod/
```

Each environment contains:
- `backend.tf`
- `main.tf`
- `variables.tf`
- `terraform.tfvars`

---

## 🌱 5. Environments

### Dev
- VPC: `10.100.0.0/16`
- Instance type: `t3.micro`
- ASG: min 2, max 4
- S3 bucket: `group1-dev-web-images`

### Staging
- VPC: `10.200.0.0/16`
- Instance type: `t3.small`
- ASG: min 3, max 4

### Prod
- VPC: `10.250.0.0/16`
- Instance type: `t3.medium`
- ASG: min 3, max 4

---

## ⚙️ 6. Features Implemented

✔ Custom VPC with subnets  
✔ NAT Gateway  
✔ Application Load Balancer  
✔ Auto Scaling Group  
✔ IAM Role for EC2  
✔ S3 bucket for images  
✔ Remote S3 backend  
✔ GitHub Actions TFLint + Trivy  
✔ User-data configured for web app  
✔ Multi-AZ deployment  

---

## 🚀 7. Deployment Steps

### Clone
```bash
git clone https://github.com/<user>/acs730-final-project-group1.git
cd envs/dev
```

### Initialize Terraform
```bash
terraform init
```

### Plan
```bash
terraform plan
```

### Apply
```bash
terraform apply -auto-approve
```

### Output Load Balancer URL
```bash
terraform output alb_dns_name
```

---

## 🔍 8. Validation & Testing

### ALB
- AWS Console → Target Groups → **Healthy** instances

### Auto Scaling
Terminate an instance:
```bash
aws ec2 terminate-instances --instance-ids <ID>
```
ASG should launch a new one automatically.

### S3
During boot, EC2 downloads:
```
flower.jpg
```

### Browser Test
Refresh ALB DNS multiple times → responses should alternate across instances.

---

## 🔐 9. GitHub Actions

Workflow:  
`.github/workflows/terraform-security.yml`

Runs:
- **TFLint** (lint Terraform code)
- **Trivy** (IaC vulnerability scan)

Triggered on:
- Push to `staging`
- PR to `prod`

---

## 📸 10. Required Screenshots (Add these in your report)

- VPC overview  
- Subnets list  
- NAT Gateway  
- ALB + Target Group (healthy)  
- ASG instance list  
- S3 bucket with images  
- Browser screenshot  
- GitHub Actions run output  
- Terraform apply output  

---

## 🧩 11. Challenges & Learning

Some example challenges:
- Fixing ALB health checks  
- Correct IAM policies for S3  
- Ensuring user-data executes correctly  
- Multi-environment Terraform structure  
- Debugging GitHub Actions workflows  

---

## 👥 12. Contributors
| Name               | Seneca ID  | GitHub        |
|-------------------|------------|---------------|
| Md Abu Sayeed     | 128626249  | abusayeed29   |
| Dhruv Patel       | 135452241  | dhruvPatel47  |
| Shadhana Ravikumar| 108025255  | sravikumar10  |
| Amir Bhandari     | 153633235  | amirbhan369   |
| Syed Raza Hasnain | 126850254  | rhasnain1     |

---

## 📜 13. License

Created for **ACS730 – Cloud Automation**, Seneca Polytechnic.

