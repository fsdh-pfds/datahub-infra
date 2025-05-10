resource "azurerm_linux_function_app" "datahub_function_ps_secure" {
  name                        = local.func_app_name_ps_secure
  resource_group_name         = var.az_resource_group
  location                    = var.az_region
  service_plan_id             = azurerm_service_plan.datahub_portal_app_service_plan.id
  functions_extension_version = "~4"

  storage_account_name       = data.azurerm_storage_account.datahub_storageaccount.name
  storage_account_access_key = data.azurerm_storage_account.datahub_storageaccount.primary_access_key

  identity { type = "SystemAssigned" }

  site_config { always_on = var.app_service_always_on }

  app_settings = {
    "ApplicationInsightsAgent_EXTENSION_VERSION"      = "~3"
    "XDT_MicrosoftApplicationInsights_Mode"           = "recommended"
    "InstrumentationEngine_EXTENSION_VERSION"         = "~1"
    "XDT_MicrosoftApplicationInsights_BaseExtensions" = "~1"
    "APPLICATIONINSIGHTS_CONNECTION_STRING"           = var.app_insights_str
    "DataHub_ENVNAME"                                 = var.environment_name
    "FUNCTIONS_WORKER_RUNTIME"                        = "powershell"
    "AzureWebJobsStorage"                             = data.azurerm_storage_account.datahub_storageaccount.primary_connection_string
    "AzureWebJobsDashboard"                           = data.azurerm_storage_account.datahub_storageaccount.primary_connection_string

    "EmailNotification__SmtpHost"      = var.smtp_host
    "EmailNotification__SmtpPort"      = var.smtp_port
    "EmailNotification__SmtpUsername"  = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_smtp_username})"
    "EmailNotification__SmtpPassword"  = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_smtp_password})"
    "EmailNotification__SenderName"    = var.smtp_sender_name
    "EmailNotification__SenderAddress" = var.smtp_sender_address
  }

  connection_string {
    name  = "datahub_mssql_project"
    type  = "SQLServer"
    value = "Server=tcp:${var.sql_server_dns},1433;Database=${var.sql_database_project};Authentication=Active Directory Managed Identity;Encrypt=True;Trusted_Connection=False;"
  }

  tags = merge(
    var.common_tags
  )

  lifecycle {
    ignore_changes = [
      virtual_network_subnet_id,
      storage_key_vault_secret_id,
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
      app_settings["APPINSIGHTS_INSTRUMENTATIONKEY"],
      app_settings["APPLICATIONINSIGHTS_CONNECTION_STRING"]
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "log_function_ps_secure" {
  name                       = "spdatahub-log-function-ps-secure"
  target_resource_id         = azurerm_linux_function_app.datahub_function_ps_secure.id
  log_analytics_workspace_id = var.log_workspace_id
  storage_account_id         = var.storage_account_id

  enabled_log {
    category = "FunctionAppLogs"
  }

  metric {
    category = "AllMetrics"
  }
}

resource "azurerm_role_assignment" "kv_role_function_ps_secure" {
  for_each = local.kv_user_roles

  scope                = var.key_vault_id
  principal_id         = azurerm_linux_function_app.datahub_function_ps_secure.identity.0.principal_id
  role_definition_name = each.key
}

