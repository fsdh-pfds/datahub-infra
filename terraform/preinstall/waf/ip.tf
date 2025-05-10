resource "azurerm_public_ip" "datahub_public_ip" {
  name                = "${var.resource_prefix}_public_ip-${var.environment_name}"
  location            = var.az_region
  resource_group_name = var.az_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = merge(
    var.common_tags
  )
}