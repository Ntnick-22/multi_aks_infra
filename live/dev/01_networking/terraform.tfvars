vnet_name     = "dev-mei-vnet"
address_space = ["10.0.0.0/16"]

subnets = {
  "dev-mei-subnet" = {
    address_prefixes = ["10.0.1.0/24"]
  }
  "dev-aks-subnet" = {
    address_prefixes = ["10.0.2.0/24"]
  }
}
