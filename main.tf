resource "random_pet" "suffix" {}

locals {
  suffix = "umami-${random_pet.suffix.id}"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.suffix}"
  location = var.location
}

module "mysql" {
  source = "./mysql"

  rg_name  = azurerm_resource_group.rg.name
  location = var.location
  suffix   = local.suffix
}

module "app_service" {
  source = "./app_service"

  rg_name  = azurerm_resource_group.rg.name
  location = var.location
  suffix   = local.suffix
}
