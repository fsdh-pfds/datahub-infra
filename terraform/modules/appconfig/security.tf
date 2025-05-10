
resource "azurerm_user_assigned_identity" "datahub_app_config_identity" {
  name                = local.app_config_identity
  resource_group_name = var.az_resource_group
  location            = var.az_region
}

resource "azurerm_role_assignment" "aconf_group_role" {
  scope                = azurerm_app_configuration.datahub_app_config.id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = var.aad_group_admin_oid
}

resource "azurerm_role_assignment" "aconf_creator_contributor" {
  scope                = azurerm_app_configuration.datahub_app_config.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "aconf_creator_data" {
  scope                = azurerm_app_configuration.datahub_app_config.id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "datahub_akv_app_config_role_secret" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.datahub_app_config_identity.principal_id
}

resource "azurerm_role_assignment" "datahub_akv_app_config_role_crypto" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = azurerm_user_assigned_identity.datahub_app_config_identity.principal_id
}
