resource "azurerm_app_configuration_key" "aconf_tenant_id" {
  configuration_store_id = azurerm_app_configuration.datahub_app_config.id
  key                    = var.global_var.config_name.tenant_id
  value                  = local.config_value.tenant_id

  depends_on = [azurerm_role_assignment.aconf_creator_contributor, azurerm_role_assignment.aconf_creator_data]
}

resource "azurerm_app_configuration_key" "aconf_log_workspace_id" {
  configuration_store_id = azurerm_app_configuration.datahub_app_config.id
  key                    = var.global_var.config_name.log_workspace_id
  value                  = local.config_value.log_workspace_id

  depends_on = [azurerm_app_configuration_key.aconf_tenant_id]
}

resource "azurerm_app_configuration_key" "aconf_sp_client_id" {
  configuration_store_id = azurerm_app_configuration.datahub_app_config.id
  key                    = var.global_var.config_name.sp_client_id
  type                   = "vault"
  vault_key_reference    = data.azurerm_key_vault_secret.sp_client_id.versionless_id

  depends_on = [azurerm_app_configuration_key.aconf_tenant_id]
  lifecycle { ignore_changes = [value] }
}

resource "azurerm_app_configuration_key" "aconf_sp_client_secret" {
  configuration_store_id = azurerm_app_configuration.datahub_app_config.id
  key                    = var.global_var.config_name.sp_client_secret
  type                   = "vault"
  vault_key_reference    = data.azurerm_key_vault_secret.sp_client_secret.versionless_id

  depends_on = [azurerm_app_configuration_key.aconf_tenant_id]
  lifecycle { ignore_changes = [value] }
}

resource "azurerm_app_configuration_key" "aconf_app_insights_key" {
  configuration_store_id = azurerm_app_configuration.datahub_app_config.id
  key                    = var.global_var.config_name.app_insights_key
  value                  = var.app_insights_key

  depends_on = [azurerm_app_configuration_key.aconf_tenant_id]
}

resource "azurerm_app_configuration_key" "aconf_smtp_host" {
  configuration_store_id = azurerm_app_configuration.datahub_app_config.id
  key                    = var.global_var.config_name.smtp_host
  value                  = var.smtp_host

  depends_on = [azurerm_app_configuration_key.aconf_tenant_id]
}

resource "azurerm_app_configuration_key" "aconf_smtp_port" {
  configuration_store_id = azurerm_app_configuration.datahub_app_config.id
  key                    = var.global_var.config_name.smtp_port
  value                  = var.smtp_port

  depends_on = [azurerm_app_configuration_key.aconf_tenant_id]
}

resource "azurerm_app_configuration_key" "aconf_smtp_sender_name" {
  configuration_store_id = azurerm_app_configuration.datahub_app_config.id
  key                    = var.global_var.config_name.smtp_sender_name
  value                  = var.smtp_sender_name

  depends_on = [azurerm_app_configuration_key.aconf_tenant_id]
}

resource "azurerm_app_configuration_key" "aconf_smtp_sender_address" {
  configuration_store_id = azurerm_app_configuration.datahub_app_config.id
  key                    = var.global_var.config_name.smtp_sender_address
  value                  = var.smtp_sender_address

  depends_on = [azurerm_app_configuration_key.aconf_tenant_id]
}

resource "azurerm_app_configuration_key" "aconf_smtp_username" {
  configuration_store_id = azurerm_app_configuration.datahub_app_config.id
  key                    = var.global_var.config_name.smtp_username
  type                   = "vault"
  vault_key_reference    = data.azurerm_key_vault_secret.smtp_username.versionless_id

  depends_on = [azurerm_app_configuration_key.aconf_tenant_id]
  lifecycle { ignore_changes = [value] }
}

resource "azurerm_app_configuration_key" "aconf_smtp_password" {
  configuration_store_id = azurerm_app_configuration.datahub_app_config.id
  key                    = var.global_var.config_name.smtp_password
  type                   = "vault"
  vault_key_reference    = data.azurerm_key_vault_secret.smtp_password.versionless_id

  depends_on = [azurerm_app_configuration_key.aconf_tenant_id]
  lifecycle { ignore_changes = [value] }
}
