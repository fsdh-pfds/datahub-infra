resource "azurerm_role_assignment" "kv_role_storage" {
  for_each = toset(["Key Vault Crypto User", "Key Vault Certificate User", "Key Vault Secrets User", "Key Vault Crypto Service Encryption User"])

  scope                = var.key_vault_id
  principal_id         = azurerm_storage_account.datahub_storageaccount.identity.0.principal_id
  role_definition_name = each.key
}

resource "azurerm_role_assignment" "kv_role_public_storage" {
  for_each = toset(["Key Vault Crypto User", "Key Vault Certificate User", "Key Vault Secrets User"])

  scope                = var.key_vault_id
  principal_id         = azurerm_storage_account.datahub_storageaccount_public.identity.0.principal_id
  role_definition_name = each.key
}

resource "azurerm_storage_account_customer_managed_key" "datahub_storageaccount_key" {
  storage_account_id = azurerm_storage_account.datahub_storageaccount.id
  key_vault_id       = var.key_vault_id
  key_name           = var.key_vault_cmk_name

  depends_on = [azurerm_role_assignment.kv_role_storage]
}

resource "azurerm_storage_account_customer_managed_key" "datahub_storageaccount_pub_key" {
  storage_account_id = azurerm_storage_account.datahub_storageaccount_public.id
  key_vault_id       = var.key_vault_id
  key_name           = var.key_vault_cmk_name

  depends_on = [azurerm_role_assignment.kv_role_public_storage]
}

data "azurerm_storage_account_sas" "datahub_storageaccount_sas" {
  connection_string = azurerm_storage_account.datahub_storageaccount.primary_connection_string
  https_only        = true
  signed_version    = "2017-07-29"

  resource_types {
    service   = true
    container = false
    object    = false
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = "2020-03-31"
  expiry = "2023-03-31"

  permissions {
    read    = true
    write   = true
    delete  = false
    list    = false
    add     = true
    create  = true
    update  = false
    process = false
    filter  = false
    tag     = true
  }
}

data "azurerm_storage_account_blob_container_sas" "datahub_app_log_sas" {
  connection_string = azurerm_storage_account.datahub_storageaccount.primary_connection_string
  container_name    = azurerm_storage_container.datahub_app_log.name
  https_only        = true

  start  = "2020-03-31"
  expiry = "2031-03-31"

  permissions {
    read   = true
    add    = true
    create = true
    write  = true
    delete = true
    list   = true
  }
}

data "azurerm_storage_account_blob_container_sas" "datahub_backup_sas" {
  connection_string = azurerm_storage_account.datahub_storageaccount.primary_connection_string
  container_name    = azurerm_storage_container.datahub_backup.name
  https_only        = true

  #ip_address = "168.1.5.65"

  start  = "2022-01-01"
  expiry = "2031-12-31"

  permissions {
    read   = true
    add    = true
    create = true
    write  = true
    delete = false
    list   = false
  }
}

data "azurerm_storage_account_blob_container_sas" "datahub_test_container_sas" {
  connection_string = azurerm_storage_account.datahub_storageaccount.primary_connection_string
  container_name    = azurerm_storage_container.datahub_testing.name
  https_only        = true

  start  = "2022-01-01"
  expiry = "2025-12-31"

  permissions {
    read   = true
    create = true
    write  = true
    delete = true
    list   = true
    add    = true
  }

  cache_control       = "max-age=5"
  content_disposition = "inline"
  content_encoding    = "deflate"
  content_language    = "en-US"
}

resource "azurerm_key_vault_secret" "datahub_blob" {
  name         = "DataHub-Blob-Access-Key"
  value        = azurerm_storage_account.datahub_storageaccount.primary_access_key
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "datahub_blob_key_tfbackend" {
  name         = "fsdh-terraform-backend-accesskey"
  value        = azurerm_storage_account.datahub_storageaccount_tfbackend.primary_access_key
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "datahub_sas" {
  name         = "DataHub-Storage-SAS"
  value        = data.azurerm_storage_account_sas.datahub_storageaccount_sas.sas
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "datahub_upload_test_sas" {
  name         = "datahub-upload-test-sas"
  value        = "${azurerm_storage_account.datahub_storageaccount.primary_blob_endpoint}${azurerm_storage_container.datahub_testing.name}/${data.azurerm_storage_account_blob_container_sas.datahub_test_container_sas.sas}"
  key_vault_id = var.key_vault_id
}


resource "azurerm_key_vault_secret" "datahub_storage_queue_conn_str" {
  name         = "datahub-storage-queue-conn-str"
  value        = azurerm_storage_account.datahub_storageaccount.primary_connection_string
  key_vault_id = var.key_vault_id
}

resource "azurerm_role_assignment" "blob_creator_role" {
  scope                = azurerm_storage_account.datahub_storageaccount.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

