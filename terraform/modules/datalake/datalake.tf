resource "azurerm_storage_account" "datalake_gen2" {
  name                            = local.datalake_storage_account_name
  location                        = var.az_region
  resource_group_name             = var.az_resource_group
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  is_hns_enabled                  = true
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
    ignore_changes  = [customer_managed_key]
  }
}

resource "azurerm_storage_share" "datahub_file_share_gen2" {
  name                 = "datahub"
  storage_account_name = azurerm_storage_account.datalake_gen2.name
  quota                = 512
}

resource "azurerm_storage_data_lake_gen2_filesystem" "datahub_gen2" {
  name               = local.datahub_filesystem
  storage_account_id = azurerm_storage_account.datalake_gen2.id
  owner              = var.aad_group_admin_oid
  group              = var.aad_group_admin_oid

  ace {
    type        = "user"
    id          = var.aad_group_admin_oid
    permissions = "rwx"
  }

  ace {
    type        = "group"
    id          = var.aad_group_admin_oid
    permissions = "r-x"
  }

  ace {
    type        = "other"
    permissions = "--x"
  }

  ace {
    scope       = "default"
    type        = "user"
    permissions = "rwx"
  }

  ace {
    scope       = "default"
    type        = "group"
    permissions = "r-x"
  }

  ace {
    scope       = "default"
    type        = "other"
    permissions = "--x"
  }

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [azurerm_role_assignment.datalake_gen2_group_role]
}

resource "azurerm_role_assignment" "datalake_gen2_creator_role" {
  scope                = azurerm_storage_account.datalake_gen2.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "datalake_gen2_group_role" {
  scope                = azurerm_storage_account.datalake_gen2.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.aad_group_admin_oid
}

resource "azurerm_monitor_diagnostic_setting" "log_gen2_storage" {
  name                       = "datahub-log-gen2"
  target_resource_id         = "${azurerm_storage_account.datalake_gen2.id}/blobServices/default/"
  log_analytics_workspace_id = var.log_workspace_id
  storage_account_id         = data.azurerm_storage_account.datahub_storageaccount.id

  metric {
    category = "Capacity"
    enabled  = true
  }
  metric {
    category = "Transaction"
    enabled  = true
  }
  enabled_log {
    category = "StorageDelete"
  }
  enabled_log {
    category = "StorageRead"
  }
  enabled_log {
    category = "StorageWrite"
  }
}
