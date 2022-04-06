resource "random_pet" "suffix" {}

locals {
  suffix = "umami-${random_pet.suffix.id}"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.suffix}"
  location = var.location
}

module "key_vault" {
  source = "./key_vault"

  rg_name  = azurerm_resource_group.rg.name
  location = var.location
  suffix   = local.suffix
}

module "mysql" {
  source = "./mysql"

  rg_name      = azurerm_resource_group.rg.name
  location     = var.location
  suffix       = local.suffix
  key_vault_id = module.key_vault.key_vault_id
}

resource "random_uuid" "umami_salt" {}

module "app_service" {
  source = "./app_service"

  rg_name      = azurerm_resource_group.rg.name
  location     = var.location
  suffix       = local.suffix
  key_vault_id = module.key_vault.key_vault_id

  app_settings = {
    "DATABASE_URL" = "@Microsoft.KeyVault(SecretUri=${module.mysql.db_url_secret_id})"
    "HASH_SALT"    = random_uuid.umami_salt.result
  }
}
