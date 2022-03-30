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

  application_stack {
    node_version = "16-lts"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_app_service_source_control" "repo" {
  app_id   = azurerm_linux_web_app.app.id
  repo_url = "https://github.com/mikecao/umami"
  branch   = "master"
}
