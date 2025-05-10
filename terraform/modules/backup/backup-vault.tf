resource "azurerm_data_protection_backup_vault" "datahub_backup_vault" {
  name                = local.backup_vault_name
  resource_group_name = var.az_resource_group
  location            = var.az_region
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"

  identity {
    type = "SystemAssigned"
  }

  tags = merge(
    var.common_tags
  )
}