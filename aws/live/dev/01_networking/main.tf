module "vpc" {
  source     = "../../../modules/aws_vpc"
  vpc_name   = var.vpc_name
  cidr_block = var.cidr_block
  subnets    = var.subnets
  tags       = var.tags
}
