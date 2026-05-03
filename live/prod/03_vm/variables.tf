variable "vms" {
  description = "Map of VMs to create"
  type = map(object({
    size           = string
    admin_username = string
    subnet_key            = string
    admin_ssh_public_key  = string
    additional_inbound_rules = optional(list(object({
      name     = string
      priority = number
      port     = string
      protocol = string
      source   = string
    })), [])
  }))
}
