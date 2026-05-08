data "terraform_remote_state" "rg" {
  backend = "azurerm"
  config = {
    resource_group_name  = "multi-env-infra-sg"
    storage_account_name = "meitfstate123"
    container_name       = "tfstate"
    key                  = "dev/00_rg/terraform.tfstate"
  }
}

resource "random_password" "admin_password" {
  length           = 16
  override_special = "!#$%&*()-_=+[]{}<>:?"
  special          = true
}

module "sql_server" {
  source  = "Azure/avm-res-sql-server/azurerm"
  version = "~> 0.2"

  name                         = var.sql_server_name
  location                     = var.location
  resource_group_name          = data.terraform_remote_state.rg.outputs.resource_group_name
  server_version               = "12.0"
  administrator_login          = var.administrator_login
  administrator_login_password = random_password.admin_password.result
  enable_telemetry             = false
  databases                    = var.databases
  tags                         = var.tags
}
