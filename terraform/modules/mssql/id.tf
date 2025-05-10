resource "azurerm_user_assigned_identity" "datahub_mssql_uai" {
  name                = "fsdh-mssql-uai-${var.environment_name}"
  resource_group_name = var.az_resource_group
  location            = var.az_region
}

resource "azurerm_role_assignment" "kv_role_mssql_uai" {
  scope                = var.key_vault_id
  principal_id         = azurerm_user_assigned_identity.datahub_mssql_uai.principal_id
  role_definition_name = "Key Vault Crypto User"
}

