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

  app_settings = merge(var.app_settings, { "DOCKER_REGISTRY_SERVER_URL" = "https://ghcr.io" })

  site_config {
    application_stack {
      docker_image     = "mikecao/umami"
      docker_image_tag = "mysql-latest"
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
