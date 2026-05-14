<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vm"></a> [vm](#module\_vm) | ../../../modules/azure_vm | n/a |

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.network](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.rg](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_ssh_public_key"></a> [admin\_ssh\_public\_key](#input\_admin\_ssh\_public\_key) | SSH public key content for all VMs | `string` | n/a | yes |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Admin username for all VMs | `string` | n/a | yes |
| <a name="input_vms"></a> [vms](#input\_vms) | Map of VMs to create | <pre>map(object({<br/>    size                  = string<br/>    subnet_key            = string<br/>    ip_forwarding_enabled = optional(bool, false)<br/>    os_image              = optional(string, "ubuntu-24.04")<br/>    additional_inbound_rules = optional(list(object({<br/>      name     = string<br/>      priority = number<br/>      port     = string<br/>      protocol = string<br/>      source   = string<br/>    })), [])<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_ips"></a> [private\_ips](#output\_private\_ips) | Map of VM keys to their private IP addresses |
| <a name="output_public_ips"></a> [public\_ips](#output\_public\_ips) | Map of VM keys to their public IP addresses |
| <a name="output_vm_names"></a> [vm\_names](#output\_vm\_names) | Map of VM keys to their provisioned names |
<!-- END_TF_DOCS -->