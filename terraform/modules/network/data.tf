data "azurerm_client_config" "current" {}

data "azurerm_storage_account" "datahub_storageaccount" {
  name                = var.storage_account_name
  resource_group_name = var.az_resource_group
}

data "azurerm_key_vault_key" "datahub_cmk" {
  name         = var.key_vault_cmk_name
  key_vault_id = var.key_vault_id
}

data "azurerm_data_protection_backup_vault" "datahub_backup_vault" {
  name                = var.backup_vault_name
  resource_group_name = var.az_resource_group
}

locals {
  vnet_name          = "${var.resource_prefix}-vnet-${var.environment_name}"
  domain_dns_main    = "dsapp-sand.scienceprogram.cloud"
  domain_dns_san     = ["dsapp-sand.ssc.gc.ca"]
  paz_name           = "subnet-paz"
  oz_name            = "subnet-oz"
  rz_name            = "subnet-rz"
  az_name            = "subnet-app"
  kv_conn_name       = "datahub-kv-connection"
  sql_conn_name      = "datahub-sql-connection"
  storage_conn_name  = "datahub-storage-connection"
  datalake_conn_name = "datahub-datalake-connection"
}

