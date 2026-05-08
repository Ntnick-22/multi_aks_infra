locals {
  os_images = {
    "ubuntu-24.04" = {
      publisher = "Canonical"
      offer     = "ubuntu-24_04-lts"
      sku       = "server"
    }
    "ubuntu-22.04" = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
    }
  }

  selected_image = local.os_images[var.os_image]

  ssh_rule = [{
    name     = "AllowSSH"
    priority = 100
    port     = "22"
    protocol = "Tcp"
    source   = var.ssh_source_address
  }]

  all_inbound_rules = concat(local.ssh_rule, var.additional_inbound_rules)

  default_tags = {
    managed_by = "terraform"
    module     = "azure_vm"
  }
  all_tags = merge(local.default_tags, var.tags)
}

resource "azurerm_public_ip" "pip" {
  name                = "pip-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.all_tags
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.all_tags

  dynamic "security_rule" {
    for_each = local.all_inbound_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = security_rule.value.protocol
      source_port_range          = "*"
      destination_port_range     = security_rule.value.port
      source_address_prefix      = security_rule.value.source
      destination_address_prefix = "*"
    }
  }
}

resource "azurerm_network_interface" "nic" {
  name                  = "nic-${var.name}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  ip_forwarding_enabled = var.ip_forwarding_enabled

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "assoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic.id]
  tags                  = local.all_tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = local.selected_image.publisher
    offer     = local.selected_image.offer
    sku       = local.selected_image.sku
    version   = "latest"
  }
}
