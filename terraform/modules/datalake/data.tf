data "azurerm_client_config" "current" {}

data "azurerm_storage_account" "datahub_storageaccount" {
  name                = var.storage_account_name
  resource_group_name = var.az_resource_group
}

locals {
  datalake_storage_account_name = "${var.resource_prefix}datalake${var.environment_name}"
  datahub_filesystem            = "datahub"
}
