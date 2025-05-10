
resource "azurerm_storage_account" "datahub_storageaccount_tfbackend" {
  name                            = local.blob_tfbackend_name
  location                        = var.az_region
  resource_group_name             = var.az_resource_group
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  is_hns_enabled                  = false
  allow_nested_items_to_be_public = false

  identity {
    type = "SystemAssigned"
  }

  blob_properties {
    last_access_time_enabled = "true"
  }

  tags = merge(
    var.common_tags
  )

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [customer_managed_key] # Refer to azurerm_storage_account_customer_managed_key.datahub_storageaccount_key
  }
}

resource "azurerm_storage_container" "tfbackend_project_states" {
  name                  = "fsdh-project-states"
  storage_account_name  = azurerm_storage_account.datahub_storageaccount_tfbackend.name
  container_access_type = "private"
}
