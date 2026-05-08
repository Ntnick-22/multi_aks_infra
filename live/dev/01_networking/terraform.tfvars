vnet_name     = "dev-sai-vnet"
address_space = ["10.0.0.0/16"]

subnets = {
  "dev-sai-subnet" = {
    address_prefixes = ["10.0.1.0/24"]
  }
}
