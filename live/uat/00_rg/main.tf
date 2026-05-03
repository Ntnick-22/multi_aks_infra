module "rg" {
  source   = "../../../modules/azure_rg"
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}
