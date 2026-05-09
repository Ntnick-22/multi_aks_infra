data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "single-dev-demo"
    key    = "dev/01_networking/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "ec2" {
  for_each = var.instances

  source                   = "../../../modules/aws_ec2"
  name                     = each.key
  vpc_id                   = data.terraform_remote_state.network.outputs.vpc_id
  subnet_id                = data.terraform_remote_state.network.outputs.subnet_ids[each.value.subnet_key]
  instance_type            = each.value.instance_type
  ami_id                   = data.aws_ami.ubuntu.id
  admin_ssh_public_key     = file(pathexpand(each.value.admin_ssh_public_key))
  additional_inbound_rules = each.value.additional_inbound_rules
  tags                     = var.tags
}
