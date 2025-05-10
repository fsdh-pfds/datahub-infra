data "azurerm_client_config" "current" {}

locals {
  resource_group_name   = "${var.resource_prefix}-${var.environment_name}-proj-rg"
  resource_group_region = "canadacentral"
}

