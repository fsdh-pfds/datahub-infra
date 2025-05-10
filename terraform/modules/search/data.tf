data "azurerm_client_config" "current" {}

data "azurerm_storage_account" "datahub_storageaccount" {
  name                = var.storage_account_name
  resource_group_name = var.az_resource_group
}

data "azurerm_storage_account" "datahub_datalake_gen2" {
  name                = var.datalake_storage_account_name
  resource_group_name = var.az_resource_group
}

data "azurerm_key_vault_key" "datahub_cmk" {
  name         = var.key_vault_cmk_name
  key_vault_id = var.key_vault_id
}

data "azurerm_log_analytics_workspace" "datahub_log" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.az_resource_group
}

data "azurerm_data_protection_backup_vault" "datahub_backup_vault" {
  name                = var.backup_vault_name
  resource_group_name = var.az_resource_group
}

locals {
  search_name = "${var.resource_prefix}-search-${var.environment_name}"
}
