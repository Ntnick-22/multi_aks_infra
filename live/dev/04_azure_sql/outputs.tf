output "sql_server_id" {
  description = "Resource ID of the SQL Server"
  value       = module.sql_server.resource_id
}

output "sql_server_name" {
  description = "Name of the SQL Server"
  value       = module.sql_server.resource_name
}

output "admin_password" {
  description = "Auto-generated SQL Server admin password"
  value       = random_password.admin_password.result
  sensitive   = true
}
