admin_username = "azureuser"

vms = {
  "openvpn-server" = {
    size                  = "Standard_D2s_v3"
    subnet_key            = "dev-sai-subnet"
    ip_forwarding_enabled = true
    additional_inbound_rules = [
      {
        name     = "AllowOpenVPN"
        priority = 200
        port     = "1194"
        protocol = "Udp"
        source   = "*"
      }
    ]
  }

  "web-server" = {
    size       = "Standard_B2s"
    subnet_key = "dev-sai-subnet"
    additional_inbound_rules = [
      {
        name     = "AllowHTTP"
        priority = 200
        port     = "80"
        protocol = "Tcp"
        source   = "*"
      },
      {
        name     = "AllowHTTPS"
        priority = 210
        port     = "443"
        protocol = "Tcp"
        source   = "*"
      }
    ]
  }
}
