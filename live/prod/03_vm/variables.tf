variable "vms" {
  description = "Map of VMs to create"
  type = map(object({
    size           = string
    admin_username = string
    subnet_key            = string
    admin_ssh_public_key   = string
    ip_forwarding_enabled  = optional(bool, false)
    os_image               = optional(string, "ubuntu-24.04")
    additional_inbound_rules = optional(list(object({
      name     = string
      priority = number
      port     = string
      protocol = string
      source   = string
    })), [])
  }))
}
