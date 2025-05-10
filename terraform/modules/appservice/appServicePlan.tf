
resource "azurerm_service_plan" "datahub_portal_app_service_plan" {
  name                = "${var.resource_prefix}-portal-app-plan-${var.environment_name}"
  resource_group_name = var.az_resource_group
  location            = var.az_region
  sku_name            = var.app_service_sku
  os_type             = "Linux"
  worker_count        = 1

  tags = merge(
    var.common_tags
  )
}
