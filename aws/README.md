# AWS Dev Infra — Progress Notes

## What this is
Single dev environment on AWS. Mirrors the Azure multi_aks_infra style — same module pattern, same remote state pattern, same layered live structure. Just dev, no UAT/prod.

## Infrastructure details
- Region: eu-west-1
- State bucket: single-dev-demo (created manually via CLI)
- DynamoDB lock table: dev-tfstate-lock (created manually via CLI)
- AWS Account ID: 772297676546

## Structure
```
aws/
  modules/
    aws_vpc/       # VPC, subnets (public+private), IGW, EIP, NAT GW, route tables
    aws_ec2/       # EC2, IAM role + instance profile (SSM), key pair, security group
  live/
    dev/
      01_networking/   # calls aws_vpc module
      02_ec2/          # reads 01_networking remote state, calls aws_ec2 module
```

## Architecture
- 2 public subnets (eu-west-1a, eu-west-1b) — NAT GW lives here, no EC2
- 2 private subnets (eu-west-1a, eu-west-1b) — EC2 lives here
- 1 NAT Gateway + EIP in dev-public-1a
- 2 EC2 instances (dev-web-01 in private-1a, dev-web-02 in private-1b), t3.micro, Ubuntu 22.04
- EC2 access via SSM Session Manager — no bastion, no open ports
- EC2 outbound internet via NAT GW

## Auth — GitHub Actions OIDC
Workflow: .github/workflows/aws-dev-apply.yml
Manual trigger (workflow_dispatch), pick layer: 01_networking or 02_ec2.

Uses aws-actions/configure-aws-credentials@v4 with role-to-assume: ${{ secrets.AWS_ROLE_ARN }}

## What is DONE
- [x] modules/aws_vpc (main, variables, outputs)
- [x] modules/aws_ec2 (main, variables, outputs)
- [x] live/dev/01_networking (all files)
- [x] live/dev/02_ec2 (all files)
- [x] .github/workflows/aws-dev-apply.yml
- [x] S3 bucket + DynamoDB created manually via CLI

## What is PENDING — pick up here next time

### Step 1 — Create IAM OIDC provider (run once in AWS account)
```bash
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1 \
  --region eu-west-1
```

### Step 2 — Create trust policy file
```bash
cat > trust-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::772297676546:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:Ntnick-22/multi_aks_infra:*"
        }
      }
    }
  ]
}
EOF
```

### Step 3 — Create IAM role
```bash
aws iam create-role \
  --role-name github-actions-terraform-dev \
  --assume-role-policy-document file://trust-policy.json
```

### Step 4 — Attach AdministratorAccess
```bash
aws iam attach-role-policy \
  --role-name github-actions-terraform-dev \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
```

### Step 5 — Get role ARN and add to GitHub
```bash
aws iam get-role \
  --role-name github-actions-terraform-dev \
  --query Role.Arn \
  --output text
```
Add output as GitHub secret: AWS_ROLE_ARN
Path: GitHub repo → Settings → Secrets and variables → Actions

### Step 6 — Run workflow
1. Push aws/ folder to GitHub
2. Go to Actions → AWS Dev Terraform Apply
3. Run workflow_dispatch → pick 01_networking → apply
4. Run workflow_dispatch → pick 02_ec2 → apply

### Step 7 — Test SSM access
```bash
aws ssm start-session --target <instance-id> --region eu-west-1
```
instance-id comes from terraform output in 02_ec2

### Step 8 — Verify NAT is working (from inside EC2 via SSM)
```bash
curl https://ifconfig.me   # should return the EIP address
```
