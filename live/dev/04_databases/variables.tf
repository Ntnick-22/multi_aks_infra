variable "postgres_servers" {
  type = map(object({
    server_name = string
    version     = string
    sku_name    = string
    storage_mb  = number
  }))
  default = {}
}

variable "postgres_server_admin_passwords" {
  type      = map(string)
  sensitive = true
  default   = {}
}

variable "sql_servers" {
  type = map(object({
    server_name = string
    version     = string
    sku_name    = string
  }))
  default = {}
}

variable "sql_server_admin_passwords" {
  type      = map(string)
  sensitive = true
  default   = {}
}

variable "sql_databases" {
  type = map(object({
    db_name = string
  }))
  default = {}
}

variable "mongodb_clusters" {
  type = map(object({
    cluster_name           = string
    compute_tier           = string
    storage_size_in_gb     = number
    high_availability_mode = string
    shard_count            = number
  }))
  default = {}
}

variable "mongodb_cluster_passwords" {
  type      = map(string)
  sensitive = true
  default   = {}
}

variable "db_admin_username" {
  type    = string
  default = "dbadmin"
}
