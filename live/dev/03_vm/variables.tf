variable "admin_username" {
  description = "Admin username for all VMs"
  type        = string
}

variable "admin_ssh_public_key" {
  description = "SSH public key content for all VMs"
  type        = string
  sensitive   = true
}

variable "vms" {
  description = "Map of VMs to create"
  type = map(object({
    size                  = string
    subnet_key            = string
    ip_forwarding_enabled = optional(bool, false)
    os_image              = optional(string, "ubuntu-24.04")
    additional_inbound_rules = optional(list(object({
      name     = string
      priority = number
      port     = string
      protocol = string
      source   = string
    })), [])
  }))
}
