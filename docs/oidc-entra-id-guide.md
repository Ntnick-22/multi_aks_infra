# OIDC + Entra ID + AKS RBAC Guide

## Overview

Passwordless auth chain: GitHub Actions uses OIDC to prove identity to Azure,
gets a token, then accesses AKS. No secrets stored anywhere.

---

## Key Values

| Item | Value |
|---|---|
| SP Name | `github-terraform-oidc` |
| APP_ID (Client ID) | `ecbdae83-ab60-44d9-9b43-d3ed444dadc3` |
| SP OBJECT_ID | `6183943e-36f1-443a-942f-cc031414bbdb` |
| Subscription ID | `df03e5ee-3b97-4f29-8a7b-0c1a55015171` |
| Tenant ID | `8a436f32-22bd-4fac-b699-3097d5d58ba9` |
| AKS Cluster | `dev-mei-aks` |
| Resource Group | `dev-infra-rg` |

---

## Part 1 — OIDC Setup (One Time)

### 1. Create App Registration + Service Principal

```bash
APP_NAME="github-terraform-oidc"
APP_ID=$(az ad app create --display-name "$APP_NAME" --query appId -o tsv)
az ad sp create --id "$APP_ID"
```

- **App Registration** — the application identity (global)
- **Service Principal** — the instance of that app in your tenant (local)

### 2. Create Federated Credential

```json
{
  "name": "github-terraform-oidc",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:Ntnick-22/multi_aks_infra:ref:refs/heads/main",
  "audiences": ["api://AzureADTokenExchange"]
}
```

```bash
az ad app federated-credential create \
  --id "$APP_ID" \
  --parameters credential.json
```

Tells Azure: trust GitHub's OIDC token from this specific repo and branch.

### 3. Assign Azure RBAC Roles

```bash
# Terraform needs to create/manage resources
az role assignment create --assignee "$APP_ID" \
  --role "Contributor" \
  --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/dev-infra-rg"

# Terraform state backend
az role assignment create --assignee "$APP_ID" \
  --role "Reader" \
  --scope "$TFSTATE_SCOPE"

az role assignment create --assignee "$APP_ID" \
  --role "Storage Blob Data Contributor" \
  --scope "$TFSTATE_SCOPE"
```

### 4. Set GitHub Secrets

```bash
gh secret set AZURE_CLIENT_ID --body "$APP_ID"
gh secret set AZURE_TENANT_ID --body "$TENANT_ID"
gh secret set AZURE_SUBSCRIPTION_ID --body "$SUBSCRIPTION_ID"
```

---

## Part 2 — AKS Setup

### Terraform Config (Entra ID + Kubernetes RBAC)

```hcl
azure_active_directory_role_based_access_control {
  tenant_id          = data.azurerm_client_config.current.tenant_id
  azure_rbac_enabled = false
}
```

`azure_rbac_enabled = false` means:
- Entra ID handles **authentication** (who you are)
- Kubernetes RBAC handles **authorization** (what you can do)

### AKS Auth Setup (One Time After Cluster Created)

**Step 1 — Azure role assignment (lets SP fetch kubeconfig):**
```bash
az role assignment create \
  --assignee $APP_ID \
  --role "Azure Kubernetes Service Cluster User Role" \
  --scope "$AKS_SCOPE"
```

**Step 2 — Get admin kubeconfig locally:**
```bash
az aks get-credentials \
  --resource-group dev-infra-rg \
  --name dev-mei-aks \
  --admin
```

**Step 3 — Create ClusterRoleBinding (Kubernetes RBAC):**
```bash
kubectl create clusterrolebinding github-oidc-admin \
  --clusterrole=cluster-admin \
  --user=6183943e-36f1-443a-942f-cc031414bbdb
```

### GitHub Actions Workflow (Every Run)

```yaml
- name: Azure Login via OIDC
  uses: azure/login@v2
  with:
    client-id: ${{ secrets.AZURE_CLIENT_ID }}
    tenant-id: ${{ secrets.AZURE_TENANT_ID }}
    subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

- name: Install kubectl + kubelogin
  run: az aks install-cli

- name: Get AKS credentials
  run: |
    az aks get-credentials \
      --resource-group dev-infra-rg \
      --name dev-mei-aks \
      --overwrite-existing
    kubelogin convert-kubeconfig -l azurecli

- name: Test kubectl access
  run: |
    kubectl get nodes
    kubectl get namespaces
```

### Final Status

```
OIDC Login            OK
Azure Login           OK
AKS Credential Fetch  OK
kubelogin             OK
kubectl Access        OK
```

---

## Part 3 — Three Identity Layers

| Layer | Purpose | Tool |
|---|---|---|
| Entra ID | Authentication — who you are | App Registration, Users, Groups |
| Azure RBAC | Azure resource access | `az role assignment` |
| Kubernetes RBAC | Cluster access | `kubectl`, ClusterRoleBinding |

---

## Part 4 — Entra ID Practice

### Identity Types

| Type | Created By | Used For |
|---|---|---|
| Service Principal | You manually | GitHub Actions, external tools |
| User Assigned Managed Identity | You, but Azure manages | Assign to multiple Azure resources |
| System Assigned Managed Identity | Azure automatically | One resource talking to another |

### Create User

```bash
az ad user create \
  --display-name "AKS Dev User" \
  --user-principal-name "aksdevuser@nyeinthunaing322gmail.onmicrosoft.com" \
  --password "TempPass123!" \
  --force-change-password-next-sign-in false
```

### Create Group + Add User

```bash
az ad group create \
  --display-name "AKS Dev Team" \
  --mail-nickname "aks-dev-team"

az ad group member add \
  --group <GROUP_ID> \
  --member-id <USER_ID>
```

### App Roles

Define custom roles inside App Registration. When user logs in, role appears as a claim in their token.

```json
[{
  "allowedMemberTypes": ["User"],
  "description": "Can read AKS resources",
  "displayName": "AKS Reader",
  "isEnabled": true,
  "value": "aks.reader",
  "id": "00000000-0000-0000-0000-000000000001"
}]
```

```bash
az ad app update \
  --id $APP_ID \
  --app-roles @approles.json
```

Token claim result:
```json
"roles": ["aks.reader"]
```

---

## Part 5 — Azure RBAC Practice

### Scope Levels (Broad → Narrow)

```
/subscriptions/<id>                           → entire subscription
/subscriptions/<id>/resourceGroups/<rg>       → one resource group
/subscriptions/<id>/resourceGroups/<rg>/...   → one resource
```

### SP Role Assignments

| Role | Scope |
|---|---|
| `Contributor` | `dev-infra-rg` only |
| `Reader` | tfstate storage only |
| `Storage Blob Data Contributor` | tfstate storage only |
| `Azure Kubernetes Service Cluster User Role` | `dev-mei-aks` only |

### Custom Role

```json
{
  "Name": "AKS Read Only",
  "Description": "Can only view AKS clusters",
  "Actions": [
    "Microsoft.ContainerService/managedClusters/read",
    "Microsoft.ContainerService/managedClusters/listClusterUserCredential/action"
  ],
  "NotActions": [],
  "AssignableScopes": ["/subscriptions/<id>"]
}
```

```bash
az role definition create --role-definition @aks-readonly-role.json
```

---

## Part 6 — Kubernetes RBAC Practice

### ClusterRoleBinding (cluster-wide)

```bash
kubectl create clusterrolebinding github-oidc-admin \
  --clusterrole=cluster-admin \
  --user=<OBJECT_ID>
```

### RoleBinding (namespace-scoped)

```bash
# Individual user
kubectl create rolebinding aksdevuser-readonly \
  --clusterrole=view \
  --user=<USER_OBJECT_ID> \
  --namespace=dev

# Group
kubectl create rolebinding aks-dev-team-readonly \
  --clusterrole=view \
  --group=<GROUP_OBJECT_ID> \
  --namespace=dev
```

### Custom ClusterRole

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log"]
  verbs: ["get", "list", "watch"]
```

```bash
kubectl apply -f cr.yaml

kubectl create rolebinding pod-reader-binding \
  --clusterrole=pod-reader \
  --user=<USER_OBJECT_ID> \
  --namespace=dev
```

### Test Permissions

```bash
kubectl auth can-i get pods --namespace=dev --as=<USER_OBJECT_ID>
kubectl auth can-i delete pods --namespace=dev --as=<USER_OBJECT_ID>
kubectl auth can-i get pods --namespace=default --as=<USER_OBJECT_ID>
```

### Role vs ClusterRole

| | Role | ClusterRole |
|---|---|---|
| Scope | One namespace | Entire cluster |
| Binding | RoleBinding | ClusterRoleBinding |
| Use case | Team access to one env | Admin/cluster-wide access |

---

## Troubleshooting

| Error | Cause | Fix |
|---|---|---|
| `AADSTS700213` | Wrong federated credential subject | Check `repo:OWNER/REPO:ref:refs/heads/BRANCH` |
| `kubelogin not found` | Missing kubelogin | `az aks install-cli` |
| `nodes is forbidden` | Missing ClusterRoleBinding | `kubectl create clusterrolebinding` |
| `az aks get-credentials fails` | Missing Cluster User Role | Assign `Azure Kubernetes Service Cluster User Role` |
| `B2s VM rejected` | B-series not allowed for system node pools | Use `Standard_D2s_v3` |
