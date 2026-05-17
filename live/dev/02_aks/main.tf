data "azurerm_client_config" "current" {}

data "terraform_remote_state" "rg" {
  backend = "azurerm"
  config = {
    resource_group_name  = "multi-env-infra-sg"
    storage_account_name = "meitfstate123"
    container_name       = "tfstate"
    key                  = "dev/00_rg/terraform.tfstate"
  }
}

data "terraform_remote_state" "networking" {
  backend = "azurerm"
  config = {
    resource_group_name  = "multi-env-infra-sg"
    storage_account_name = "meitfstate123"
    container_name       = "tfstate"
    key                  = "dev/01_networking/terraform.tfstate"
  }
}

module "aks" {
  source              = "../../../modules/azure_aks"
  resource_group_name = data.terraform_remote_state.rg.outputs.resource_group_name
  location            = data.terraform_remote_state.rg.outputs.resource_group_location
  cluster_name        = var.cluster_name
  dns_prefix          = var.dns_prefix
  node_count          = var.node_count
  vm_size             = var.vm_size
  subnet_id           = data.terraform_remote_state.networking.outputs.subnet_ids["dev-aks-subnet"]
  tenant_id           = data.azurerm_client_config.current.tenant_id
}
