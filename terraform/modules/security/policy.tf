resource "azurerm_role_assignment" "kv_role_databricks" {
  for_each = toset(["Key Vault Crypto User", "Key Vault Certificate User", "Key Vault Secrets User"])

  scope                = var.key_vault_id
  principal_id         = var.azure_databricks_sp
  role_definition_name = each.key
}
