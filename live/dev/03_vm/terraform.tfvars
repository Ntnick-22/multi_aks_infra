admin_username = "azureuser"

vms = {
   
  "openvpn-server" = {
    size                  = "Standard_D2s_v3"
    subnet_key            = "dev-mei-subnet"
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
    size       = "Standard_D2s_v3"
    subnet_key = "dev-mei-subnet"
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


#   # --- Docker Swarm Lab Nodes ---

#   "swarm-manager" = {
#     size       = "Standard_B1ms"
#     subnet_key = "dev-sai-subnet"
#     additional_inbound_rules = [
#       {
#         name     = "AllowSwarmMgmt"
#         priority = 200
#         port     = "2377"
#         protocol = "Tcp"
#         source   = "VirtualNetwork"
#       },
#       {
#         name     = "AllowSwarmGossip"
#         priority = 210
#         port     = "7946"
#         protocol = "*"
#         source   = "VirtualNetwork"
#       },
#       {
#         name     = "AllowSwarmOverlay"
#         priority = 220
#         port     = "4789"
#         protocol = "Udp"
#         source   = "VirtualNetwork"
#       },
#       {
#         name     = "AllowHTTP8080"
#         priority = 230
#         port     = "8080"
#         protocol = "Tcp"
#         source   = "*"
#       },
#       {
#         name     = "AllowBackend5001"
#         priority = 240
#         port     = "5001"
#         protocol = "Tcp"
#         source   = "*"
#       }
#     ]
#   }

#   "swarm-worker-1" = {
#     size       = "Standard_B1ms"
#     subnet_key = "dev-sai-subnet"
#     additional_inbound_rules = [
#       {
#         name     = "AllowSwarmMgmt"
#         priority = 200
#         port     = "2377"
#         protocol = "Tcp"
#         source   = "VirtualNetwork"
#       },
#       {
#         name     = "AllowSwarmGossip"
#         priority = 210
#         port     = "7946"
#         protocol = "*"
#         source   = "VirtualNetwork"
#       },
#       {
#         name     = "AllowSwarmOverlay"
#         priority = 220
#         port     = "4789"
#         protocol = "Udp"
#         source   = "VirtualNetwork"
#       },
#       {
#         name     = "AllowHTTP8080"
#         priority = 230
#         port     = "8080"
#         protocol = "Tcp"
#         source   = "*"
#       },
#       {
#         name     = "AllowBackend5001"
#         priority = 240
#         port     = "5001"
#         protocol = "Tcp"
#         source   = "*"
#       }
#     ]
#   }

#   "swarm-worker-2" = {
#     size       = "Standard_B1ms"
#     subnet_key = "dev-sai-subnet"
#     additional_inbound_rules = [
#       {
#         name     = "AllowSwarmMgmt"
#         priority = 200
#         port     = "2377"
#         protocol = "Tcp"
#         source   = "VirtualNetwork"
#       },
#       {
#         name     = "AllowSwarmGossip"
#         priority = 210
#         port     = "7946"
#         protocol = "*"
#         source   = "VirtualNetwork"
#       },
#       {
#         name     = "AllowSwarmOverlay"
#         priority = 220
#         port     = "4789"
#         protocol = "Udp"
#         source   = "VirtualNetwork"
#       },
#       {
#         name     = "AllowHTTP8080"
#         priority = 230
#         port     = "8080"
#         protocol = "Tcp"
#         source   = "*"
#       },
#       {
#         name     = "AllowBackend5001"
#         priority = 240
#         port     = "5001"
#         protocol = "Tcp"
#         source   = "*"
#       }
#     ]
#   }
# }
