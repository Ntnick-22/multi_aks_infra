terraform {
  backend "azurerm" {
    resource_group_name  = "multi-env-infra-sg"
    storage_account_name = "meitfstate123"
    container_name       = "tfstate"
    key                  = "dev/02_aks/terraform.tfstate"
  }
}
