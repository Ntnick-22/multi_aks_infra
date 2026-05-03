terraform {
  backend "azurerm" {
    resource_group_name  = "sai-rg"
    storage_account_name = "saitfstate123"
    container_name       = "tfstate"
    key                  = "prod/03_vm/terraform.tfstate"
  }
}
