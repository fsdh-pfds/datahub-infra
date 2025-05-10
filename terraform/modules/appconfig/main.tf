resource "azurerm_app_configuration" "datahub_app_config" {
  name                       = local.app_config_name
  resource_group_name        = var.az_resource_group
  location                   = var.az_region
  sku                        = "standard"
  local_auth_enabled         = false
  public_network_access      = "Enabled"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.datahub_app_config_identity.id]
  }
  encryption {
    key_vault_key_identifier = var.key_vault_cmk_id
    identity_client_id       = azurerm_user_assigned_identity.datahub_app_config_identity.client_id
  }

  tags       = merge(var.common_tags)
  depends_on = [azurerm_role_assignment.datahub_akv_app_config_role_crypto]
}
