output "app_msi_principal_id" {
  value = azurerm_linux_web_app.app.identity.0.principal_id
}

output "app_outbound_ip_address_list" {
  value = azurerm_linux_web_app.app.outbound_ip_address_list
}
