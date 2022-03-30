output "app_msi_principal_id" {
  type  = string
  value = azurerm_linux_web_app.identity.0.principal_id
}
