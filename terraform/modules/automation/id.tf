
resource "azurerm_user_assigned_identity" "proj_common_uami" {
  name                = "proj-common-uami-${var.environment_name}"
  resource_group_name = var.az_resource_group
  location            = var.az_region
}

resource "azurerm_key_vault_secret" "proj_common_auto_acct_client_id" {
  name         = "proj-common-auto-acct-uai-clientid"
  value        = azurerm_user_assigned_identity.proj_common_uami.client_id
  key_vault_id = var.key_vault_id
}

resource "azurerm_role_assignment" "automation_acct_uami_assignment" {
  scope                = data.azurerm_subscription.az_subscription.id
  role_definition_name = "Billing Reader"
  principal_id         = azurerm_user_assigned_identity.proj_common_uami.principal_id
}

resource "azurerm_key_vault_secret" "proj_common_auto_acct_uai_id" {
  name         = "proj-common-auto-acct-uai-id"
  value        = azurerm_user_assigned_identity.proj_common_uami.id
  key_vault_id = var.key_vault_id
}
