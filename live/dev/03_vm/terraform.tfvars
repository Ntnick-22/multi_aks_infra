vms = {
  "OPENVPN-SERVER" = {
    size                 = "Standard_D2s_v3"
    admin_username       = "azureuser"
    subnet_key           = "sai-subnet"
    admin_ssh_public_key = "~/.ssh/sai_rsa.pub"
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
}
