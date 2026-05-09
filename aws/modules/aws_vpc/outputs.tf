output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_ids" {
  value = { for k, v in aws_subnet.subnet : k => v.id }
}

output "public_subnet_ids" {
  value = { for k in keys(local.public_subnets) : k => aws_subnet.subnet[k].id }
}

output "private_subnet_ids" {
  value = { for k in keys(local.private_subnets) : k => aws_subnet.subnet[k].id }
}
