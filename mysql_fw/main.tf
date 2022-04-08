resource "azurerm_mysql_flexible_server_firewall_rule" "rules" {
  for_each = toset(var.ip_address_list)

  name                = "allowedIpAddress-${index(var.ip_address_list, each.key)}"
  resource_group_name = var.rg_name
  server_name         = var.server_name
  start_ip_address    = each.key
  end_ip_address      = each.key
}
