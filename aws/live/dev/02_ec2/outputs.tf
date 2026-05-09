output "instance_ids" {
  value = { for k, v in module.ec2 : k => v.instance_id }
}

output "private_ips" {
  value = { for k, v in module.ec2 : k => v.private_ip }
}
