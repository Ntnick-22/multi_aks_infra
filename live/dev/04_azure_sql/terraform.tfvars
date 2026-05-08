location            = "uksouth"
sql_server_name     = "sqlserver-dev-sai-02"
administrator_login = "sqladmin"

databases = {
  app_db = {
    name        = "app_db"
    sku_name    = "Basic"
    max_size_gb = 2
    collation   = "SQL_Latin1_General_CP1_CI_AS"
    short_term_retention_policy = {
      retention_days           = 7
      backup_interval_in_hours = 12
    }
  }
}

tags = {
  environment = "dev"
  managed_by  = "terraform"
}
