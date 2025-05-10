
resource "azurerm_monitor_diagnostic_setting" "log_keyvault" {
  name                       = "spdatahub-log-keyvault"
  target_resource_id         = var.key_vault_id
  log_analytics_workspace_id = var.log_workspace_id
  storage_account_id         = azurerm_storage_account.datahub_storageaccount.id

  enabled_log { category = "AuditEvent" }

  metric { category = "AllMetrics" }
}
