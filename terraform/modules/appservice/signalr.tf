
resource "azurerm_signalr_service" "datahub_signalr" {
  name                = local.signalr_name
  resource_group_name = var.az_resource_group
  location            = var.az_region

  sku {
    name     = "Free_F1"
    capacity = 1
  }

  service_mode = "Default"

  lifecycle {
    prevent_destroy = false
  }

  tags = merge(
    var.common_tags
  )
}
