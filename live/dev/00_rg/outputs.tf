output "resource_group_name" {
  description = "Name of the provisioned Azure resource group"
  value       = module.rg.resource_group_name
}

output "resource_group_location" {
  description = "Azure region where the resource group is deployed"
  value       = module.rg.resource_group_location
}
