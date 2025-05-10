resource "azurerm_network_security_group" "datahub_nsg_app" {
  name                = "${var.resource_prefix}-nsg-app-service-${var.environment_name}"
  location            = var.az_region
  resource_group_name = var.az_resource_group

  tags = merge(
    var.common_tags
  )
}

resource "azurerm_subnet_network_security_group_association" "datahub_nsg_app_link" {
  subnet_id                 = azurerm_subnet.subnet_app.id
  network_security_group_id = azurerm_network_security_group.datahub_nsg_app.id
}

resource "azurerm_network_security_rule" "nsg_rule_app_to_kv" {
  name                        = "nsg-rule-app-to-kv"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_port_range      = "443"
  destination_address_prefix  = "AzureKeyVault.CanadaCentral"
  resource_group_name         = var.az_resource_group
  network_security_group_name = azurerm_network_security_group.datahub_nsg_app.name
}

resource "azurerm_network_security_rule" "nsg_rule_app_to_storage" {
  name                        = "nsg-rule-app-to-storage"
  priority                    = 102
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_port_range      = "443"
  destination_address_prefix  = "Storage.CanadaCentral"
  resource_group_name         = var.az_resource_group
  network_security_group_name = azurerm_network_security_group.datahub_nsg_app.name
}

resource "azurerm_network_security_rule" "nsg_rule_app_to_sql" {
  name                        = "nsg-rule-app-to-sql"
  priority                    = 103
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_port_range      = "1433"
  destination_address_prefix  = "Sql.CanadaCentral"
  resource_group_name         = var.az_resource_group
  network_security_group_name = azurerm_network_security_group.datahub_nsg_app.name
}

resource "azurerm_network_security_rule" "nsg_rule_app_to_service_ip" {
  name                         = "nsg-rule-app-to-ip"
  priority                     = 110
  direction                    = "Outbound"
  access                       = "Allow"
  protocol                     = "Tcp"
  source_port_range            = "*"
  destination_port_ranges      = ["443", "1433"]
  source_address_prefix        = "VirtualNetwork"
  destination_address_prefixes = azurerm_subnet.subnet_rz.address_prefixes
  resource_group_name          = var.az_resource_group
  network_security_group_name  = azurerm_network_security_group.datahub_nsg_app.name
}
