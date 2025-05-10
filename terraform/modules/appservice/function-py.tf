resource "azurerm_linux_function_app" "datahub_function_py" {
  name                        = local.func_app_name_py
  resource_group_name         = var.az_resource_group
  location                    = var.az_region
  functions_extension_version = "~4"
  service_plan_id             = azurerm_service_plan.datahub_portal_app_service_plan.id
  storage_key_vault_secret_id = data.azurerm_key_vault_secret.secret_storage_account.versionless_id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack { python_version = "3.11" }
  }

  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.app_insights_str_func_py
    "DataHub_ENVNAME"                       = var.environment_name
    "FUNCTIONS_WORKER_RUNTIME"              = "python"
    "FUNCTIONS_EXTENSION_VERSION"           = "~4"
    "AzureWebJobsStorage"                   = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_datahub_storage_queue_conn_str}/)"
    "AzureWebJobsDashboard"                 = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_datahub_storage_queue_conn_str}/)"
    "AzureClientId"                         = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_devops_client_id})"
    "AzureClientSecret"                     = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_devops_client_secret})"
    "AzureStorageQueueConnectionString"     = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_datahub_storage_queue_conn_str})"

    "DatahubServiceBus"                     = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${var.service_bus_connection_string_secret_name})"

    "AzureTenantId"            = var.az_tenant_id
    "AzureSubscriptionId"      = var.az_subscription_id
    "AzureWebJobsFeatureFlags" = "EnableWorkerIndexing"
  }

  tags = merge(
    var.common_tags
  )

  lifecycle {
    ignore_changes = [
      virtual_network_subnet_id,
      storage_key_vault_secret_id
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "log_function_py" {
  name                       = "spdatahub-log-function-py"
  target_resource_id         = azurerm_linux_function_app.datahub_function_py.id
  log_analytics_workspace_id = var.log_workspace_id
  storage_account_id         = var.storage_account_id

  enabled_log {
    category = "FunctionAppLogs"
  }

  metric {
    category = "AllMetrics"
  }
}

resource "azurerm_role_assignment" "kv_role_function_py" {
  for_each = local.kv_user_roles

  scope                = var.key_vault_id
  principal_id         = azurerm_linux_function_app.datahub_function_py.identity.0.principal_id
  role_definition_name = each.key
}

