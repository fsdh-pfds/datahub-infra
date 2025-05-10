output "project_automation_acct_name" {
  value = azurerm_automation_account.project_common_automation_acct.name
}

output "project_automation_acct_rg" {
  value = azurerm_automation_account.project_common_automation_acct.resource_group_name
}

output "project_common_automation_acct_uami" {
  value = azurerm_user_assigned_identity.proj_common_uami.client_id
}

output "project_common_auto_acct_uai_clientid" {
  value = azurerm_user_assigned_identity.proj_common_uami.client_id
}

output "project_common_auto_acct_uai_id" {
  value = azurerm_user_assigned_identity.proj_common_uami.id
}

output "project_common_auto_acct_uai_name" {
  value = azurerm_user_assigned_identity.proj_common_uami.name
}

output "project_common_auto_acct_uai_rg" {
  value = azurerm_user_assigned_identity.proj_common_uami.resource_group_name
}

output "project_common_auto_acct_uai_sub" {
  value = var.az_subscription_id
}
