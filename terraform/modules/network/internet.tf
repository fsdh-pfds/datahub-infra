resource "azurerm_public_ip" "datahub_public_ip" {
  name                = "${var.resource_prefix}-public-ip-${var.environment_name}"
  resource_group_name = var.az_resource_group
  location            = var.az_region
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]

  tags = merge(
    var.common_tags
  )
}

# App service and function app can check their outbound IP: "$ip = Invoke-RestMethod http://ipinfo.io/json; $ip.ip"
resource "azurerm_nat_gateway" "datahub_nat_gateway" {
  name                    = "${var.resource_prefix}-nat-gateway-${var.environment_name}"
  location                = var.az_region
  resource_group_name     = var.az_resource_group
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]

  lifecycle {
    ignore_changes = [tags["ClientOrganization"], tags["CloudUsageProfile"], tags["DataSensitivity"], tags["Environment"], tags["ProjectEmail"], tags["ProjectName"], tags["TechnicalEmail"]]
  }
}

resource "azurerm_subnet_nat_gateway_association" "datahub_nat_gateway_subnet" {
  subnet_id      = azurerm_subnet.subnet_app.id
  nat_gateway_id = azurerm_nat_gateway.datahub_nat_gateway.id
}

resource "azurerm_nat_gateway_public_ip_association" "datahub_nat_gateway_ip" {
  nat_gateway_id       = azurerm_nat_gateway.datahub_nat_gateway.id
  public_ip_address_id = azurerm_public_ip.datahub_public_ip.id
}
