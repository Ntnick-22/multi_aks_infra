variable "location" {
  description = "Azure region for SQL Server — overrides RG region if SQL is restricted there"
  type        = string
  default     = "eastus"
}

variable "sql_server_name" {
  description = "Name of the SQL Server — must be globally unique across all of Azure"
  type        = string
}

variable "administrator_login" {
  description = "SQL Server admin username"
  type        = string
  default     = "sqladmin"
}

variable "databases" {
  description = "Map of databases to create on the SQL Server"
  type = map(object({
    name        = string
    sku_name    = optional(string, "Basic")
    max_size_gb = optional(number, 2)
    collation   = optional(string, "SQL_Latin1_General_CP1_CI_AS")
    short_term_retention_policy = optional(object({
      retention_days           = number
      backup_interval_in_hours = optional(number, 12)
    }))
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
