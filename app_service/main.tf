resource "azurerm_service_plan" "plan" {
  name                = "plan-${var.suffix}"
  resource_group_name = var.rg_name
  location            = var.location

  os_type  = "Linux"
  sku_name = "B1"
}

resource "azurerm_linux_web_app" "app" {
  name                = "web-${var.suffix}"
  resource_group_name = var.rg_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.plan.id

  app_settings = var.app_settings

  site_config {
    application_stack {
      node_version = "16-lts"
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "kv_app_secrets" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_web_app.app.identity.0.principal_id
}

resource "azurerm_app_service_source_control" "repo" {
  app_id                 = azurerm_linux_web_app.app.id
  repo_url               = "https://github.com/mikecao/umami"
  branch                 = "master"
  use_manual_integration = true
}
