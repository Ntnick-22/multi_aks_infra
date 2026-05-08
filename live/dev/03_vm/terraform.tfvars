vms = {
  "openvpn-server" = {
    size                  = "Standard_D2s_v3"
    admin_username        = "azureuser"
    subnet_key            = "dev-sai-subnet"
    admin_ssh_public_key  = "~/.ssh/sai_rsa.pub"
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
    size                 = "Standard_B2s"
    admin_username       = "azureuser"
    subnet_key           = "dev-sai-subnet"
    admin_ssh_public_key = "~/.ssh/sai_rsa.pub"
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
