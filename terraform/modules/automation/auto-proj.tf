resource "azurerm_automation_account" "project_common_automation_acct" {
  name                = local.proj_common_automation_acct_name
  resource_group_name = var.az_resource_group
  location            = var.az_region
  sku_name            = "Basic"

  identity { type = "SystemAssigned" }
  tags = merge(var.common_tags)
}

resource "azurerm_role_assignment" "project_common_automation_acct_assignment" {
  scope                = data.azurerm_subscription.az_subscription.id
  role_definition_name = "Billing Reader"
  principal_id         = azurerm_automation_account.project_common_automation_acct.identity[0].principal_id
}

resource "azurerm_key_vault_secret" "project_common_automation_acct_secret" {
  name         = local.secret_name_common_auto_acct
  value        = azurerm_automation_account.project_common_automation_acct.name
  key_vault_id = var.key_vault_id
}


