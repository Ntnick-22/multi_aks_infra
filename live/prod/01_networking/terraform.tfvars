vnet_name     = "prod-sai-vnet"
address_space = ["10.2.0.0/16"]

subnets = {
  "prod-sai-subnet" = {
    address_prefixes = ["10.2.1.0/24"]
  }
}
