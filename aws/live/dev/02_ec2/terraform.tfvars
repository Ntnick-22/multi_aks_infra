region = "eu-west-1"

instances = {
  "dev-web-01" = {
    subnet_key               = "dev-private-1a"
    instance_type            = "t3.micro"
    admin_ssh_public_key     = "~/.ssh/id_rsa.pub"
    additional_inbound_rules = []
  }
  "dev-web-02" = {
    subnet_key               = "dev-private-1b"
    instance_type            = "t3.micro"
    admin_ssh_public_key     = "~/.ssh/id_rsa.pub"
    additional_inbound_rules = []
  }
}

tags = {
  env     = "dev"
  project = "aws-dev-infra"
}
