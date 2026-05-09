data "terraform_remote_state" "rg" {
  backend = "azurerm"
  config = {
    resource_group_name  = "multi-env-infra-sg"
    storage_account_name = "meitfstate123"
    container_name       = "tfstate"
    key                  = "dev/00_rg/terraform.tfstate"
  }
}

# ============================================================
# PostgreSQL Flexible Server
# ============================================================
resource "azurerm_postgresql_flexible_server" "postgres" {
  for_each = var.postgres_servers

  name                   = each.value.server_name
  resource_group_name    = data.terraform_remote_state.rg.outputs.resource_group_name
  location               = data.terraform_remote_state.rg.outputs.resource_group_location
  version                = each.value.version
  sku_name               = each.value.sku_name
  storage_mb             = each.value.storage_mb
  administrator_login    = var.db_admin_username
  administrator_password = var.postgres_server_admin_passwords[each.key]
}

# ============================================================
# MSSQL Server
# ============================================================
resource "azurerm_mssql_server" "sql_server" {
  for_each = var.sql_servers

  name                         = each.value.server_name
  resource_group_name          = data.terraform_remote_state.rg.outputs.resource_group_name
  location                     = var.sql_server_location
  version                      = each.value.version
  administrator_login          = var.db_admin_username
  administrator_login_password = var.sql_server_admin_passwords[each.key]
}

# ============================================================
# MSSQL Database
# ============================================================
resource "azurerm_mssql_database" "sql_database" {
  for_each = var.sql_databases

  name      = each.value.db_name
  server_id = azurerm_mssql_server.sql_server[each.key].id
}

# ============================================================
# MongoDB Cluster
# ============================================================
resource "azurerm_mongo_cluster" "mongo" {
  for_each = var.mongodb_clusters

  name                   = each.value.cluster_name
  resource_group_name    = data.terraform_remote_state.rg.outputs.resource_group_name
  location               = data.terraform_remote_state.rg.outputs.resource_group_location
  compute_tier           = each.value.compute_tier
  storage_size_in_gb     = each.value.storage_size_in_gb
  high_availability_mode = each.value.high_availability_mode
  shard_count            = each.value.shard_count
  version                = each.value.version
  administrator_username = var.db_admin_username
  administrator_password = var.mongodb_cluster_passwords[each.key]
}
