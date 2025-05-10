data "azurerm_key_vault_secret" "sp_client_id" {
  name         = local.config_value.sp_client_id
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "sp_client_secret" {
  name         = local.config_value.sp_client_secret
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "smtp_username" {
  name         = local.config_value.smtp_username
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "smtp_password" {
  name         = local.config_value.smtp_password
  key_vault_id = var.key_vault_id
}
