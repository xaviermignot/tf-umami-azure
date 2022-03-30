locals {
  srv_login = azurerm_mysql_flexible_server.server.administrator_login
  srv_pass  = azurerm_mysql_flexible_server.server.administrator_password
  srv_fqdn  = azurerm_mysql_flexible_server.server.fqdn
  db_name   = azurerm_mysql_flexible_database.db.name
}

output "database_url" {
  value = "mysql://${local.srv_login}:${local.srv_pass}@${local.srv_fqdn}/${local.db_name}"
}
