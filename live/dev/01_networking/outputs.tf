output "vnet_id" {
  description = "Resource ID of the provisioned virtual network"
  value       = module.vnet.vnet_id
}

output "subnet_ids" {
  description = "Map of subnet names to their resource IDs"
  value       = module.vnet.subnet_ids
}
