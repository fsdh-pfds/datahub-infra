resource "azurerm_virtual_network" "datahub_vnet" {
  name                = local.vnet_name
  location            = var.az_region
  resource_group_name = var.az_resource_group
  address_space       = [var.datahub_vnet_cidr]

  tags = merge(
    var.common_tags
  )
}

resource "azurerm_subnet" "subnet_paz" {
  name                 = local.paz_name
  resource_group_name  = var.az_resource_group
  virtual_network_name = azurerm_virtual_network.datahub_vnet.name
  address_prefixes     = [var.subnet_paz_cidr]
}

resource "azurerm_subnet" "subnet_oz" {
  name                 = local.oz_name
  resource_group_name  = var.az_resource_group
  virtual_network_name = azurerm_virtual_network.datahub_vnet.name
  address_prefixes     = [var.subnet_oz_cidr]
}

resource "azurerm_subnet" "subnet_rz" {
  name                 = local.rz_name
  resource_group_name  = var.az_resource_group
  virtual_network_name = azurerm_virtual_network.datahub_vnet.name
  address_prefixes     = [var.subnet_rz_cidr]

}

resource "azurerm_subnet" "subnet_app" {
  name                 = local.az_name
  resource_group_name  = var.az_resource_group
  virtual_network_name = azurerm_virtual_network.datahub_vnet.name
  address_prefixes     = [var.subnet_az_cidr]
  service_endpoints    = ["Microsoft.Sql"]

  delegation {
    name = "datahub-app-service-delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

