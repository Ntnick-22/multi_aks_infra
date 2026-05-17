# GitHub OIDC + AKS kubectl Access Setup

## Current Setup

| Item | Value |
|---|---|
| GitHub Repo | `Marharbawga/gitops` |
| Resource Group | `mahar` |
| AKS Cluster | `mbr` |
| Tenant ID | `6260daf3-8575-4ac3-bec1-844ebcae1c64` |
| Subscription ID | `6f48750e-5037-4321-9d8b-a9e58c87accf` |
| GitHub OIDC App Client ID | `00c4c0b3-1f0f-4dc0-9b06-d5e1954f5b1e` |

---

# 1. Create Azure App Registration

```bash
APP_NAME="github-gitops-oidc"

APP_ID=$(az ad app create \
  --display-name $APP_NAME \
  --query appId -o tsv)

az ad sp create --id $APP_ID
```

---

# 2. Get Tenant + Subscription IDs

```bash
TENANT_ID=$(az account show --query tenantId -o tsv)
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

echo "APP_ID=$APP_ID"
echo "TENANT_ID=$TENANT_ID"
echo "SUBSCRIPTION_ID=$SUBSCRIPTION_ID"
```

---

# 3. Configure GitHub OIDC Federated Credential

```bash
GITHUB_REPO="Marharbawga/gitops"
BRANCH="main"

cat > credential.json <<EOF
{
  "name": "github-gitops-main",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:${GITHUB_REPO}:ref:refs/heads/${BRANCH}",
  "description": "GitHub Actions OIDC",
  "audiences": [
    "api://AzureADTokenExchange"
  ]
}
EOF

az ad app federated-credential create \
  --id $APP_ID \
  --parameters credential.json
```

## Important Subject Format

```text
repo:OWNER/REPO:ref:refs/heads/BRANCH
```

Example:

```text
repo:Marharbawga/gitops:ref:refs/heads/main
```

---

# 4. Grant Azure AKS Access

```bash
AKS_RG="mahar"
AKS_NAME="mbr"

AKS_SCOPE="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$AKS_RG/providers/Microsoft.ContainerService/managedClusters/$AKS_NAME"

az role assignment create \
  --assignee $APP_ID \
  --role "Azure Kubernetes Service Cluster User Role" \
  --scope $AKS_SCOPE
```

---

# 4.1 Grant Terraform Backend Storage Access

Required when this GitHub OIDC app runs Terraform using Azure Storage backend.

Terraform needs to read the storage account metadata and read/write the tfstate blob.

```bash
TFSTATE_RG="tfstate-rg"
TFSTATE_STORAGE_ACCOUNT="mbftfstatestorage"

TFSTATE_SCOPE="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$TFSTATE_RG/providers/Microsoft.Storage/storageAccounts/$TFSTATE_STORAGE_ACCOUNT"

az role assignment create \
  --assignee $APP_ID \
  --role "Reader" \
  --scope $TFSTATE_SCOPE

az role assignment create \
  --assignee $APP_ID \
  --role "Storage Blob Data Contributor" \
  --scope $TFSTATE_SCOPE
```
---

# 5. AKS RBAC Configuration

## Important

Terraform AKS config:

```hcl
azure_active_directory_role_based_access_control {
  azure_rbac_enabled = false
}
```

Because Azure RBAC is disabled:

- Azure IAM alone is NOT enough
- Kubernetes RBAC is ALSO required

---

# 6. Create Kubernetes ClusterRoleBinding

## Get admin kubeconfig locally

```bash
az aks get-credentials \
  --resource-group mahar \
  --name mbr \
  --admin \
  --overwrite-existing
```

## Create cluster-admin binding

```bash
kubectl create clusterrolebinding github-gitops-cluster-admin \
  --clusterrole=cluster-admin \
  --user=98843051-bf0f-4bf5-98e9-d52dda6916d9
```

The user ID came from GitHub Actions error:

```text
User "98843051-bf0f-4bf5-98e9-d52dda6916d9" cannot list resource "nodes"
```

---

# 7. GitHub Actions Workflow

Create:

```text
.github/workflows/kubernetes.yaml
```

```yaml
name: Test K8s Access

on:
  workflow_dispatch:

permissions:
  id-token: write
  contents: read

jobs:
  test-k8s-access:
    runs-on: ubuntu-latest

    steps:
      - name: Azure Login via OIDC
        uses: azure/login@v2
        with:
          client-id: 00c4c0b3-1f0f-4dc0-9b06-d5e1954f5b1e
          tenant-id: 6260daf3-8575-4ac3-bec1-844ebcae1c64
          subscription-id: 6f48750e-5037-4321-9d8b-a9e58c87accf

      - name: Install kubectl + kubelogin
        run: |
          az aks install-cli

      - name: Get AKS credentials
        run: |
          az aks get-credentials \
            --resource-group mahar \
            --name mbr \
            --overwrite-existing

          kubelogin convert-kubeconfig -l azurecli

      - name: Test kubectl access
        run: |
          kubectl get nodes
          kubectl get namespaces
```

---

# 8. Troubleshooting

## AADSTS700213

```text
No matching federated identity record found
```

Cause:

- Wrong federated credential subject

Check:

```text
repo:OWNER/REPO:ref:refs/heads/main
```

---

## kubelogin not found

Cause:

- Missing kubelogin install

Fix:

```yaml
- run: az aks install-cli
```

---

## nodes is forbidden

```text
cannot list resource "nodes"
```

Cause:

- Missing Kubernetes RBAC

Fix:

```bash
kubectl create clusterrolebinding ...
```

---

## az aks get-credentials fails

Cause:

- Missing Azure role assignment

Fix:

```bash
Azure Kubernetes Service Cluster User Role
```

---

# Final Status

```text
OIDC Login            OK
Azure Login           OK
AKS Credential Fetch  OK
kubelogin             OK
kubectl Access        OK
```
