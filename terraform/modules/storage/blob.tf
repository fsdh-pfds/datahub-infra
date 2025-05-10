resource "azurerm_storage_account" "datahub_storageaccount" {
  name                            = local.blob_storage_account_name
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

resource "azurerm_storage_share" "datahub_file_share_misc" {
  name                 = "datahub"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
  quota                = 512
}

resource "azurerm_storage_container" "datahub_backup" {
  name                  = "datahub-backup"
  storage_account_name  = azurerm_storage_account.datahub_storageaccount.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "datahub_log_export" {
  name                  = "datahub-log-export"
  storage_account_name  = azurerm_storage_account.datahub_storageaccount.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "datahub_data" {
  name                  = "datahub-fsdh"
  storage_account_name  = azurerm_storage_account.datahub_storageaccount.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "datahub_app_log" {
  name                  = "datahub-app-log"
  storage_account_name  = azurerm_storage_account.datahub_storageaccount.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "datahub_staging" {
  name                  = "datahub-staging"
  storage_account_name  = azurerm_storage_account.datahub_storageaccount.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "datahub_testing" {
  name                  = "datahub-testing"
  storage_account_name  = azurerm_storage_account.datahub_storageaccount.name
  container_access_type = "private"
}

resource "null_resource" "log_blob_immutable" {
  count = var.enforce_log_immunity ? 1 : 0

  provisioner "local-exec" {
    command    = "az storage container immutability-policy create --account-name ${azurerm_storage_account.datahub_storageaccount.name} -c ${azurerm_storage_container.datahub_app_log.name} -g ${var.az_resource_group} --allow-protected-append-writes true --period 3650"
    on_failure = fail
  }
}

# resource "azurerm_storage_management_policy" "datahub_delete_test_data_1d" {
#   storage_account_id = azurerm_storage_account.datahub_storageaccount.id

#   rule {
#     name    = "rule1d"
#     enabled = true
#     filters {
#       blob_types   = ["blockBlob"]
#       prefix_match = ["${azurerm_storage_container.datahub_testing.name}/"]
#     }
#     actions {
#       base_blob {
#         delete_after_days_since_modification_greater_than = 1
#       }
#     }
#   }

#   depends_on = [azurerm_role_assignment.kv_role_storage]
# }

resource "azurerm_storage_account" "datahub_storageaccount_public" {
  name                            = local.blob_storage_acct_name_pub
  location                        = var.az_region
  resource_group_name             = var.az_resource_group
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  is_hns_enabled                  = false
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = true

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

resource "azurerm_storage_container" "datahub_dist" {
  name                  = local.blob_container_name_pub
  storage_account_name  = azurerm_storage_account.datahub_storageaccount_public.name
  container_access_type = "blob"
}
