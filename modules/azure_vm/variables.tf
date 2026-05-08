# ── Required ─────────────────────────────────────────────────────────────────

variable "name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to attach the VM network interface to"
  type        = string
}

variable "size" {
  description = "VM size"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}

variable "admin_ssh_public_key" {
  description = "SSH public key content for the admin user"
  type        = string
}

# ── Optional ──────────────────────────────────────────────────────────────────

variable "ip_forwarding_enabled" {
  description = "Enable IP forwarding on the NIC — required for VPN/router VMs, false for normal servers"
  type        = bool
  default     = false
}

variable "os_image" {
  description = "OS image to use — must match a key in the local os_images map"
  type        = string
  default     = "ubuntu-24.04"

  validation {
    condition     = contains(["ubuntu-24.04", "ubuntu-22.04"], var.os_image)
    error_message = "os_image must be one of: ubuntu-24.04, ubuntu-22.04."
  }
}

variable "ssh_source_address" {
  description = "Source IP or CIDR allowed to SSH — restrict to your IP in production"
  type        = string
  default     = "*"
}

variable "tags" {
  description = "Additional tags merged with module defaults (managed_by, module)"
  type        = map(string)
  default     = {}
}

variable "additional_inbound_rules" {
  description = "Extra NSG inbound rules — priority 100 is reserved for SSH"
  type = list(object({
    name     = string
    priority = number
    port     = string
    protocol = string
    source   = string
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.additional_inbound_rules : r.priority >= 101 && r.priority <= 4096])
    error_message = "Rule priorities must be between 101 and 4096 — 100 is reserved for SSH."
  }
}
