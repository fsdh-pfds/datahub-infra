resource "azurerm_role_assignment" "kv_role_datalake" {
  for_each = toset(["Key Vault Secrets User", "Key Vault Crypto User"])

  scope                = var.key_vault_id
  principal_id         = azurerm_storage_account.datalake_gen2.identity.0.principal_id
  role_definition_name = each.key
}

resource "azurerm_storage_account_customer_managed_key" "datahub_gen2adls_key" {
  storage_account_id = azurerm_storage_account.datalake_gen2.id
  key_vault_id       = var.key_vault_id
  key_name           = var.key_vault_cmk_name

  depends_on = [azurerm_role_assignment.kv_role_datalake]
}

resource "azurerm_key_vault_secret" "datahub_gen2" {
  name         = "Datahub-StorageDL-Secret"
  value        = azurerm_storage_account.datalake_gen2.primary_access_key
  key_vault_id = var.key_vault_id
}

resource "azurerm_role_assignment" "datalake_creator_role" {
  scope                = azurerm_storage_account.datalake_gen2.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}


