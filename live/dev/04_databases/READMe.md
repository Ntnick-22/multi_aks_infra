 This module manages Azure databases (MSSQL, PostgreSQL, MongoDB).

  <!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.72.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_mongo_cluster.mongo](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mongo_cluster) | resource |
| [azurerm_mssql_database.sql_database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) | resource |
| [azurerm_mssql_server.sql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) | resource |
| [azurerm_postgresql_flexible_server.postgres](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) | resource |
| [terraform_remote_state.rg](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_db_admin_username"></a> [db\_admin\_username](#input\_db\_admin\_username) | Administrator login username for all databases | `string` | `"dbadmin"` | no |
| <a name="input_db_location"></a> [db\_location](#input\_db\_location) | Azure region for all database resources | `string` | `"northeurope"` | no |
| <a name="input_mongodb_cluster_passwords"></a> [mongodb\_cluster\_passwords](#input\_mongodb\_cluster\_passwords) | Admin passwords for MongoDB clusters | `map(string)` | `{}` | no |
| <a name="input_mongodb_clusters"></a> [mongodb\_clusters](#input\_mongodb\_clusters) | MongoDB cluster configurations | <pre>map(object({<br/>    cluster_name           = string<br/>    compute_tier           = string<br/>    storage_size_in_gb     = number<br/>    high_availability_mode = string<br/>    shard_count            = number<br/>    version                = string<br/>  }))</pre> | `{}` | no |
| <a name="input_postgres_server_admin_passwords"></a> [postgres\_server\_admin\_passwords](#input\_postgres\_server\_admin\_passwords) | Admin passwords for PostgreSQL servers | `map(string)` | `{}` | no |
| <a name="input_postgres_servers"></a> [postgres\_servers](#input\_postgres\_servers) | PostgreSQL Flexible Server configurations | <pre>map(object({<br/>    server_name = string<br/>    version     = string<br/>    sku_name    = string<br/>    storage_mb  = number<br/>  }))</pre> | `{}` | no |
| <a name="input_sql_databases"></a> [sql\_databases](#input\_sql\_databases) | MSSQL database configurations | <pre>map(object({<br/>    db_name = string<br/>  }))</pre> | `{}` | no |
| <a name="input_sql_server_admin_passwords"></a> [sql\_server\_admin\_passwords](#input\_sql\_server\_admin\_passwords) | Admin passwords for MSSQL servers | `map(string)` | `{}` | no |
| <a name="input_sql_servers"></a> [sql\_servers](#input\_sql\_servers) | MSSQL Server configurations | <pre>map(object({<br/>    server_name = string<br/>    version     = string<br/>    sku_name    = string<br/>  }))</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->