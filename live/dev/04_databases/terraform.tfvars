db_admin_username = "dbadmin"

postgres_servers = {
  production_postgres = {
    server_name = "prod-postgres"
    version     = "16"
    sku_name    = "B_Standard_B2s"
    storage_mb  = 131072
  }
}

sql_servers = {
  production_sql = {
    server_name = "prod-sql"
    version     = "12.0"
    sku_name    = "GP_Gen5_2"
  }
}

sql_databases = {
  production_sql = {
    db_name = "productiondb"
  }
}

mongodb_clusters = {
  production_mongo = {
    cluster_name           = "prod-mongo"
    compute_tier           = "M20"
    storage_size_in_gb     = 512
    high_availability_mode = "Disabled"
    shard_count            = 1
  }
}
