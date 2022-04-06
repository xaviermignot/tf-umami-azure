data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                = substr("kv-${var.suffix}", 0, 24)
  resource_group_name = var.rg_name
  location            = var.location

  sku_name                  = "standard"
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization = true
}

resource "azurerm_role_assignment" "kv_tf_secrets" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}
