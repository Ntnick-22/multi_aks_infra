variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "ec2_ssh_public_key" {
  type      = string
  sensitive = true
}

variable "instances" {
  type = map(object({
    subnet_key           = string
    instance_type        = string
    additional_inbound_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}
