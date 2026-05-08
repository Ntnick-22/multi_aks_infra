data "terraform_remote_state" "rg" {
  backend = "azurerm"
  config = {
    resource_group_name  = "multi-env-infra-sg"
    storage_account_name = "meitfstate123"
    container_name       = "tfstate"
    key                  = "prod/00_rg/terraform.tfstate"
  }
}

module "vnet" {
  source              = "../../../modules/azure_vnet"
  resource_group_name = data.terraform_remote_state.rg.outputs.resource_group_name
  location            = data.terraform_remote_state.rg.outputs.resource_group_location
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  subnets             = var.subnets
}
