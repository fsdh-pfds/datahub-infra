
resource "azurerm_network_security_group" "datahub_vnet_sg_main" {
  name                = "${var.resource_prefix}-vnet-sg-${var.environment_name}"
  location            = var.az_region
  resource_group_name = var.az_resource_group
}

resource "azurerm_network_security_group" "datahub_vnet_nsg_waf" {
  name                = "${var.resource_prefix}-nsg-waf-${var.environment_name}"
  location            = var.az_region
  resource_group_name = var.az_resource_group

  security_rule {
    name                       = "datahub-waf-required-rule-inbound1"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["65200-65535"]
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "datahub-waf-required-rule-inbound2"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "datahub-waf-required-rule-inbound443"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = merge(
    var.common_tags
  )
}

data "azurerm_subnet" "datahub_subnet_app" {
  name                 = "subnetapp"
  virtual_network_name = azurerm_virtual_network.datahub_vnet.name
  resource_group_name  = var.az_resource_group
}
