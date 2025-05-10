resource "azurerm_key_vault_secret" "datahub_mssql_password" {
  name         = "datahub-mssql-password"
  value        = random_password.datahub_sql_password.result
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "datahub_mssql_admin" {
  name         = "datahub-mssql-admin"
  value        = azurerm_mssql_server.datahub_sql_server.administrator_login
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "datahub_mssql_readonly_user" {
  name         = "datahub-mssql-readonly-username"
  value        = local.sql_username_readonly
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "datahub_mssql_readonly_password" {
  name         = "datahub-mssql-readonly-password"
  value        = random_password.datahub_readonly_password.result
  key_vault_id = var.key_vault_id
}


