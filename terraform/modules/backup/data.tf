data "azurerm_client_config" "current" {}

data "azurerm_storage_account" "datahub_storageaccount" {
  name                = var.storage_account_name
  resource_group_name = var.az_resource_group
}

locals {
  backup_vault_name = "fsdh-backup-vault-${var.environment_name}"
}
