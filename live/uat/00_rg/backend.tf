terraform {
  backend "azurerm" {
    resource_group_name  = "multi-env-infra-sg"
    storage_account_name = "meitfstate123"
    container_name       = "tfstate"
    key                  = "uat/00_rg/terraform.tfstate"
  }
}
