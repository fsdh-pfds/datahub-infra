resource "azurerm_subnet" "dbr_public" {
  name                 = "subnet_dbr_public"
  resource_group_name  = var.az_resource_group
  virtual_network_name = azurerm_virtual_network.datahub_vnet.name
  address_prefixes     = [var.subnet_dbr_pub_cidr]
  service_endpoints    = ["Microsoft.Sql"]

  delegation {
    name = "dbr-pub-vnet-integration"

    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
      ]
      name = "Microsoft.Databricks/workspaces"
    }
  }
}

resource "azurerm_subnet" "dbr_private" {
  name                 = "subnet_dbr_private"
  resource_group_name  = var.az_resource_group
  virtual_network_name = azurerm_virtual_network.datahub_vnet.name
  address_prefixes     = [var.subnet_dbr_prv_cidr]
  service_endpoints    = ["Microsoft.Sql"]

  delegation {
    name = "dbr-prv-vnet-integration"

    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
      ]
      name = "Microsoft.Databricks/workspaces"
    }
  }
}

resource "azurerm_mssql_virtual_network_rule" "mssql_vnet_rule_dbr_pub" {
  name      = "${var.resource_prefix}-${var.environment_name}-mssql-vnet-rule-dbr-pub"
  server_id = var.mssql_id
  subnet_id = azurerm_subnet.dbr_public.id
}

resource "azurerm_mssql_virtual_network_rule" "mssql_vnet_rule_dbr_prv" {
  name      = "${var.resource_prefix}-${var.environment_name}-mssql-vnet-rule-dbr-prv"
  server_id = var.mssql_id
  subnet_id = azurerm_subnet.dbr_private.id
}
