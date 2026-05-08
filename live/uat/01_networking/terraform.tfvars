vnet_name     = "uat-sai-vnet"
address_space = ["10.1.0.0/16"]

subnets = {
  "uat-sai-subnet" = {
    address_prefixes = ["10.1.1.0/24"]
  }
}
