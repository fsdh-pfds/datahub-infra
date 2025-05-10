data "azurerm_client_config" "current" {}

locals {
  app_config_name       = "${var.resource_prefix}-app-config-${var.environment_name}"
  app_config_identity   = "${var.resource_prefix}-app-config-${var.environment_name}-umi"
}
