output "db_url_secret_id" {
  value = azurerm_key_vault_secret.db_url.versionless_id
}

output "server_name" {
  value = azurerm_mysql_flexible_server.server.name
}
