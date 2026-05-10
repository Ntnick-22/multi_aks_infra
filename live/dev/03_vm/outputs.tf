output "vm_names" {
  description = "Map of VM keys to their provisioned names"
  value       = { for k, v in module.vm : k => v.vm_name }
}

output "public_ips" {
  description = "Map of VM keys to their public IP addresses"
  value       = { for k, v in module.vm : k => v.public_ip }
}

output "private_ips" {
  description = "Map of VM keys to their private IP addresses"
  value       = { for k, v in module.vm : k => v.private_ip }
}
