variable "postgres_servers" {
  description = "PostgreSQL Flexible Server configurations"
  type = map(object({
    server_name = string
    version     = string
    sku_name    = string
    storage_mb  = number
  }))
  default = {}
}

variable "postgres_server_admin_passwords" {
  description = "Admin passwords for PostgreSQL servers"
  type      = map(string)
  sensitive = true
  default   = {}
}

variable "sql_servers" {
  description = "MSSQL Server configurations"
  type = map(object({
    server_name = string
    version     = string
    sku_name    = string
  }))
  default = {}
}

variable "sql_server_admin_passwords" {
  description = "Admin passwords for MSSQL servers"
  type      = map(string)
  sensitive = true
  default   = {}
}

variable "sql_databases" {
  description = "MSSQL database configurations"
  type = map(object({
    db_name = string
  }))
  default = {}
}

variable "mongodb_clusters" {
  description = "MongoDB cluster configurations"
  type = map(object({
    cluster_name           = string
    compute_tier           = string
    storage_size_in_gb     = number
    high_availability_mode = string
    shard_count            = number
    version                = string
  }))
  default = {}
}

variable "mongodb_cluster_passwords" {
  description = "Admin passwords for MongoDB clusters"
  type      = map(string)
  sensitive = true
  default   = {}
}

variable "db_admin_username" {
  description = "Administrator login username for all databases"
  type    = string
  default = "dbadmin"
}

variable "db_location" {
  description = "Azure region for all database resources"
  type    = string
  default = "northeurope"
}
