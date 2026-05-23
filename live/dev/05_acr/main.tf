data "terraform_remote_state" "rg" {
  backend = "azurerm"
  config = {
    resource_group_name  = "multi-env-infra-sg"
    storage_account_name = "meitfstate123"
    container_name       = "tfstate"
    key                  = "dev/00_rg/terraform.tfstate"
  }
}

data "terraform_remote_state" "aks" {
  backend = "azurerm"
  config = {
    resource_group_name  = "multi-env-infra-sg"
    storage_account_name = "meitfstate123"
    container_name       = "tfstate"
    key                  = "dev/02_aks/terraform.tfstate"
  }
}

module "acr" {
  source                         = "../../../modules/azure_acr"
  acr_name                       = var.acr_name
  resource_group_name            = data.terraform_remote_state.rg.outputs.resource_group_name
  location                       = data.terraform_remote_state.rg.outputs.resource_group_location
  aks_kubelet_identity_object_id = data.terraform_remote_state.aks.outputs.kubelet_identity_object_id
}
