data "terraform_remote_state" "rg" {
  backend = "azurerm"
  config = {
    resource_group_name  = "sai-rg"
    storage_account_name = "saitfstate123"
    container_name       = "tfstate"
    key                  = "uat/00_rg/terraform.tfstate"
  }
}

data "terraform_remote_state" "network" {
  backend = "azurerm"
  config = {
    resource_group_name  = "sai-rg"
    storage_account_name = "saitfstate123"
    container_name       = "tfstate"
    key                  = "uat/01_networking/terraform.tfstate"
  }
}

module "vm" {
  for_each = var.vms

  source                   = "../../../modules/azure_vm"
  name                     = each.key
  resource_group_name      = data.terraform_remote_state.rg.outputs.resource_group_name
  location                 = data.terraform_remote_state.rg.outputs.resource_group_location
  subnet_id                = data.terraform_remote_state.network.outputs.subnet_ids[each.value.subnet_key]
  size                     = each.value.size
  admin_username           = each.value.admin_username
  admin_ssh_public_key     = file(pathexpand(each.value.admin_ssh_public_key))
  additional_inbound_rules = each.value.additional_inbound_rules
}
