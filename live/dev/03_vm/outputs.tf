output "vm_names" {
  value = { for k, v in module.vm : k => v.vm_name }
}

output "public_ips" {
  value = { for k, v in module.vm : k => v.public_ip }
}

output "private_ips" {
  value = { for k, v in module.vm : k => v.private_ip }
}
