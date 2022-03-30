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
