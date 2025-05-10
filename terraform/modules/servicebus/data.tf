data "azurerm_client_config" "current" {}

locals {
  service_bus_name          = "${var.resource_prefix}-service-bus-${var.environment_name}"
  service_bus_secret_name   = "service-bus-connection-string"
}
