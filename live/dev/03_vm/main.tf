data "terraform_remote_state" "rg" {
  backend = "azurerm"
  config = {
    resource_group_name  = "multi-env-infra-sg"
    storage_account_name = "meitfstate123"
    container_name       = "tfstate"
    key                  = "dev/00_rg/terraform.tfstate"
  }
}

data "terraform_remote_state" "network" {
  backend = "azurerm"
  config = {
    resource_group_name  = "multi-env-infra-sg"
    storage_account_name = "meitfstate123"
    container_name       = "tfstate"
    key                  = "dev/01_networking/terraform.tfstate"
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
  admin_username           = var.admin_username
  admin_ssh_public_key     = var.admin_ssh_public_key
  ip_forwarding_enabled    = each.value.ip_forwarding_enabled
  os_image                 = each.value.os_image
  additional_inbound_rules = each.value.additional_inbound_rules
}
