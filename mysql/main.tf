resource "random_password" "admin_password" {
  length  = 16
  special = true
}

resource "azurerm_mysql_flexible_server" "server" {
  name                = "mysql-server-${var.suffix}"
  resource_group_name = var.rg_name
  location            = var.location
  zone                = "1"

  sku_name    = "B_Standard_B1s"
  create_mode = "Default"

  administrator_login    = "mysql_admin"
  administrator_password = random_password.admin_password.result
}

resource "azurerm_mysql_flexible_database" "db" {
  name                = "db_umami"
  resource_group_name = var.rg_name
  server_name         = azurerm_mysql_flexible_server.server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

locals {
  srv_login = azurerm_mysql_flexible_server.server.administrator_login
  srv_pass  = azurerm_mysql_flexible_server.server.administrator_password
  srv_fqdn  = azurerm_mysql_flexible_server.server.fqdn
  db_name   = azurerm_mysql_flexible_database.db.name
}

resource "azurerm_key_vault_secret" "db_url" {
  name         = "mysql-db-url"
  value        = "mysql://${local.srv_login}:${local.srv_pass}@${local.srv_fqdn}/${local.db_name}"
  key_vault_id = var.key_vault_id
}
