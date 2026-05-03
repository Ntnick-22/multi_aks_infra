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
  description = "SSH public key for the admin user"
  type        = string
}

variable "additional_inbound_rules" {
  description = "Extra NSG inbound rules beyond SSH"
  type = list(object({
    name     = string
    priority = number
    port     = string
    protocol = string
    source   = string
  }))
  default = []
}
