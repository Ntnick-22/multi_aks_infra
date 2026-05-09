region     = "eu-west-1"
vpc_name   = "dev-vpc"
cidr_block = "10.0.0.0/16"

subnets = {
  "dev-public-1a" = {
    cidr_block        = "10.0.1.0/24"
    availability_zone = "eu-west-1a"
    public            = true
  }
  "dev-public-1b" = {
    cidr_block        = "10.0.2.0/24"
    availability_zone = "eu-west-1b"
    public            = true
  }
  "dev-private-1a" = {
    cidr_block        = "10.0.11.0/24"
    availability_zone = "eu-west-1a"
    public            = false
  }
  "dev-private-1b" = {
    cidr_block        = "10.0.12.0/24"
    availability_zone = "eu-west-1b"
    public            = false
  }
}

tags = {
  env     = "dev"
  project = "aws-dev-infra"
}
