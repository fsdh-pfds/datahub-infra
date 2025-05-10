resource "azurerm_linux_function_app" "datahub_function_dotnet" {
  name                        = local.func_app_name_dotnet
  resource_group_name         = var.az_resource_group
  location                    = var.az_region
  service_plan_id             = azurerm_service_plan.datahub_portal_app_service_plan.id
  functions_extension_version = "~4"
  storage_key_vault_secret_id = data.azurerm_key_vault_secret.secret_storage_account.versionless_id

  identity { type = "SystemAssigned" }

  site_config {
    vnet_route_all_enabled = true
    always_on              = var.app_service_always_on
    http2_enabled          = true
    use_32_bit_worker      = false

    application_insights_connection_string = var.app_insights_str_func

    application_stack {
      dotnet_version              = "8.0"
      use_dotnet_isolated_runtime = true
    }
  }

  app_settings = {
    "ApplicationInsightsAgent_EXTENSION_VERSION"      = "~3"
    "XDT_MicrosoftApplicationInsights_Mode"           = "recommended"
    "InstrumentationEngine_EXTENSION_VERSION"         = "~1"
    "XDT_MicrosoftApplicationInsights_BaseExtensions" = "~1"
    "DataHub_ENVNAME"                                 = var.environment_name
    "FUNCTIONS_WORKER_RUNTIME"                        = "dotnet-isolated"
    "AzureWebJobsStorage"                             = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_datahub_storage_queue_conn_str}/)"
    "AzureWebJobsDashboard"                           = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_datahub_storage_queue_conn_str}/)"
    "SQLDB_PROJECT"                                   = "Server=tcp:${var.sql_server_dns},1433;Initial Catalog=${var.sql_database_project};Authentication=Active Directory Managed Identity;Encrypt=True;Trusted_Connection=False;"
    "SQLDB_PIP"                                       = "Server=tcp:${var.sql_server_dns},1433;Initial Catalog=${var.sql_database_pip};Authentication=Active Directory Managed Identity;Encrypt=True;Trusted_Connection=False;"
    "datahub_mssql_project"                           = "Server=tcp:${var.sql_server_dns},1433;Initial Catalog=${var.sql_database_project};Authentication=Active Directory Managed Identity;Encrypt=True;Trusted_Connection=False;"

    "AzureDevOpsConfiguration__ClientId"     = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_devops_client_id}/)"
    "AzureDevOpsConfiguration__ClientSecret" = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_devops_client_secret}/)"
    "AzureDevOpsConfiguration__TenantId"     = data.azurerm_client_config.current.tenant_id

    "DatahubStorageConnectionString"      = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_datahub_storage_queue_conn_str}/)"
    "DatahubServiceBus__ConnectionString" = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${var.service_bus_connection_string_secret_name})"
    "Media__StorageConnectionString"      = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_datahub_media_conn_str})"
    "BugReportTeamsWebhookUrl"            = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_teams_webhook_url})"

    "EmailNotification__SmtpHost"      = var.smtp_host
    "EmailNotification__SmtpPort"      = var.smtp_port
    "EmailNotification__SmtpUsername"  = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_smtp_username}/)"
    "EmailNotification__SmtpPassword"  = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_smtp_password}/)"
    "EmailNotification__SenderName"    = var.smtp_sender_name
    "EmailNotification__SenderAddress" = var.smtp_sender_address

    "FUNC_SP_CLIENT_ID"     = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_client_id}/)"
    "FUNC_SP_CLIENT_SECRET" = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_client_secret}/)"
    "PORTAL_URL"            = "https://${local.app_service_name}.azurewebsites.net/"
    "SUBSCRIPTION_ID"       = var.az_subscription_id
    "TENANT_ID"             = data.azurerm_client_config.current.tenant_id
    "SP_GROUP_ID"           = var.default_user_group

    "ProjectUsageCRON"                 = "0 0 * * * *"
    "DocumentationRankUpdateCRON"      = "0 0 * * * *"
    "InactivityCRON"                   = "0 0 0 * * *"
    "ProjectUsageNotificationPercents" = "25,50,75,100"

    "BugReportTeamsWebhookUrl" = var.bug_report_teams_webhook_url
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
      app_settings["APPLICATIONINSIGHTS_CONNECTION_STRING"],
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "log_function_dotnet" {
  name                       = "spdatahub-log-function-dotnet"
  target_resource_id         = azurerm_linux_function_app.datahub_function_dotnet.id
  log_analytics_workspace_id = var.log_workspace_id
  storage_account_id         = var.storage_account_id

  enabled_log {
    category = "FunctionAppLogs"
  }

  metric {
    category = "AllMetrics"
  }
}

resource "azurerm_role_assignment" "kv_role_function_dotnet" {
  for_each = local.kv_user_roles

  scope                = var.key_vault_id
  principal_id         = azurerm_linux_function_app.datahub_function_dotnet.identity.0.principal_id
  role_definition_name = each.key
}

#----------------------------------------#
#         Resource Provisioner
#----------------------------------------#

resource "azurerm_linux_function_app" "res_prov_function_dotnet" {
  name                        = local.func_app_name_res_prov
  resource_group_name         = var.az_resource_group
  location                    = var.az_region
  service_plan_id             = azurerm_service_plan.datahub_portal_app_service_plan.id
  functions_extension_version = "~4"
  storage_key_vault_secret_id = data.azurerm_key_vault_secret.secret_storage_account.versionless_id

  identity { type = "SystemAssigned" }

  site_config {
    vnet_route_all_enabled = true
    always_on              = true
    http2_enabled          = true
    use_32_bit_worker      = false

    application_insights_connection_string = var.app_insights_str

    application_stack {
      dotnet_version              = "8.0"
      use_dotnet_isolated_runtime = true
    }
  }

  app_settings = {
    "ApplicationInsightsAgent_EXTENSION_VERSION"      = "~3"
    "XDT_MicrosoftApplicationInsights_Mode"           = "recommended"
    "InstrumentationEngine_EXTENSION_VERSION"         = "~1"
    "XDT_MicrosoftApplicationInsights_BaseExtensions" = "~1"
    "DataHub_ENVNAME"                                 = var.environment_name
    "AzureWebJobsStorage"                             = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_datahub_storage_queue_conn_str}/)"
    "AzureWebJobsDashboard"                           = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_datahub_storage_queue_conn_str}/)"

    "FUNC_SP_CLIENT_ID"     = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_client_id}/)"
    "FUNC_SP_CLIENT_SECRET" = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_client_secret}/)"
    "AzureClientId"         = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_client_id})"
    "AzureClientSecret"     = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_client_secret})"

    "FUNCTIONS_WORKER_RUNTIME"            = "dotnet-isolated"
    "ResourceRunRequestConnectionString"  = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_datahub_storage_queue_conn_str}/)"
    "DatahubServiceBus__ConnectionString" = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${var.service_bus_connection_string_secret_name})"

    "ModuleRepository__Url"                = "https://github.com/ssc-sp/datahub-resource-modules.git",
    "ModuleRepository__LocalPath"          = "/../tmp/",
    "ModuleRepository__Name"               = "datahub-resource-modules",
    "ModuleRepository__TemplatePathPrefix" = "templates/"
    "ModuleRepository__ModulePathPrefix"   = "modules/"
    "ModuleRepository__Branch"             = var.project_module_branch

    "InfrastructureRepository__AzureDevOpsConfiguration__ClientId"     = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_devops_client_id}/)"
    "InfrastructureRepository__AzureDevOpsConfiguration__ClientSecret" = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_devops_client_secret}/)"
    "InfrastructureRepository__AzureDevOpsConfiguration__TenantId"     = data.azurerm_client_config.current.tenant_id

    "InfrastructureRepository__ApiVersion"            = "7.1-preview.1",
    "InfrastructureRepository__Url"                   = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_infrastructure_repo_url}/)"
    "InfrastructureRepository__LocalPath"             = "/../tmp/",
    "InfrastructureRepository__Name"                  = "datahub-project-infrastructure-${var.environment_name}",
    "InfrastructureRepository__MainBranch"            = "main",
    "InfrastructureRepository__ProjectPathPrefix"     = "terraform/projects",
    "InfrastructureRepository__Username"              = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_infrastructure_repo_username}/)",
    "InfrastructureRepository__Password"              = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_infrastructure_repo_password}/)",
    "InfrastructureRepository__PullRequestUrl"        = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_infrastructure_repo_pr_url}/)"
    "InfrastructureRepository__PullRequestBrowserUrl" = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_infrastructure_repo_pr_browser_url}/)"

    "Terraform__Backend__ResourceGroupName"              = var.az_resource_group
    "Terraform__Backend__SubscriptionId"                 = var.az_subscription_id
    "Terraform__Variables__az_location"                  = var.az_region
    "Terraform__Variables__az_subscription_id"           = var.ws_subscription_id
    "Terraform__Variables__az_tenant_id"                 = var.az_tenant_id
    "Terraform__Variables__environment_classification"   = var.environment_classification
    "Terraform__Variables__environment_name"             = var.environment_name
    "Terraform__Variables__resource_prefix"              = var.resource_prefix
    "Terraform__Variables__resource_prefix_alphanumeric" = lower(replace(var.resource_prefix, "/[^a-zA-Z0-9]/", ""))
    "Terraform__Variables__log_analytics_workspace_id"   = var.log_workspace_id
    "Terraform__Variables__automation_account_uai_name"  = var.project_automation_acct_uai_name
    "Terraform__Variables__automation_account_uai_rg"    = var.project_automation_acct_uai_rg
    "Terraform__Variables__automation_account_uai_sub"   = var.project_automation_acct_uai_sub

    "Terraform__Variables__azure_databricks_enterprise_oid" = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_databricks_sp}/)"
    "Terraform__Variables__aad_admin_group_oid"             = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_admin_group_oid}/)"
    "Terraform__Variables__datahub_app_sp_oid"              = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/${local.secret_name_client_oid}/)"
    "Terraform__Variables__common_tags__system"             = "fsdh"
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
      app_settings["APPLICATIONINSIGHTS_CONNECTION_STRING"],
    ]
  }
}
