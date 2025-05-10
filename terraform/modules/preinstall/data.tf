data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "datahub_rg" {
  name = var.az_resource_group
}
