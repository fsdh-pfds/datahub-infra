resource "azurerm_linux_web_app" "datahub_portal_app_service" {
  name                    = local.app_service_name
  resource_group_name     = var.az_resource_group
  location                = var.az_region
  service_plan_id         = azurerm_service_plan.datahub_portal_app_service_plan.id
  https_only              = true
  client_affinity_enabled = true

  site_config {
    always_on              = var.app_service_always_on
    websockets_enabled     = true
    http2_enabled          = true
    use_32_bit_worker      = false
    vnet_route_all_enabled = true
    application_stack {
      dotnet_version = "8.0"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "HostingProfile"                                  = "ssc"
    "Hosting__EnvironmentName"                        = var.environment_name
    "ApplicationInsightsAgent_EXTENSION_VERSION"      = "~2"
    "XDT_MicrosoftApplicationInsights_Mode"           = "recommended"
    "InstrumentationEngine_EXTENSION_VERSION"         = "~1"
    "XDT_MicrosoftApplicationInsights_BaseExtensions" = "~1"

    "ApplicationInsights__ConnectionString" = var.app_insights_str
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = var.app_insights_key

    "AzureAd__ClientId"                = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_client_id})"
    "AzureAd__ClientSecret"            = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_client_secret})"
    "AzureAd__InfraClientId"           = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_devops_client_id})"
    "AzureAd__InfraClientSecret"       = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_devops_client_secret})"
    "AzureAd__TenantId"                = var.az_tenant_id
    "AzureAd__SubscriptionId"          = var.az_subscription_id
    "AzureAd__Domain"                  = var.aad_domain
    "AzureAd__AppIDURL"                = "https://${local.app_service_name}.azurewebsites.net/"
    "AzureAd__Instance"                = "https://login.microsoftonline.com/"
    "APITargets__StorageURL"           = "https://${var.storage_account_name}.blob.core.windows.net/datahub-fsdh"
    "APITargets__SearchServiceName"    = var.search_service_name
    "APITargets__StorageAccountName"   = var.datalake_storage_account_name
    "APITargets__KeyVaultName"         = var.key_vault_name
    "APITargets__LoginUrl"             = "https://AzureAD/Account/SignIn"
    "APITargets__LogoutUrl"            = "https://${local.app_service_name}.azurewebsites.net/"
    "APITargets__FileSystemName"       = var.datahub_filesystem
    "AZURE_TENANT_ID"                  = var.az_tenant_id
    "AZURE_CLIENT_ID"                  = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_client_id})"
    "AZURE_CLIENT_SECRET"              = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_client_secret})"
    "DataHub_ENVNAME"                  = var.environment_name
    "LOG_EXCEPTIONS"                   = "false"
    "ASPNETCORE_DETAILEDERRORS"        = "false"
    "ASPNETCORE_ENVIRONMENT"           = var.environment_name
    "Azure__SignalR__StickyServerMode" = "Required"
    "Azure__SignalR__ConnectionString" = azurerm_signalr_service.datahub_signalr.primary_connection_string

    "CONNECTIONSTRINGS__DATAHUB_MSSQL_PROJECT"          = "Server=tcp:${var.sql_server_dns},1433;Database=${var.sql_database_project};Authentication=Active Directory Managed Identity;Encrypt=True;Trusted_Connection=False;"
    "CONNECTIONSTRINGS__DATAHUB_MSSQL_PIP"              = "Server=tcp:${var.sql_server_dns},1433;Database=${var.sql_database_pip};Authentication=Active Directory Managed Identity;Encrypt=True;Trusted_Connection=False;"
    "CONNECTIONSTRINGS__DATAHUB_MSSQL_ETLDB"            = "Server=tcp:${var.sql_server_dns},1433;Database=${var.sql_database_etl};Authentication=Active Directory Managed Identity;Encrypt=True;Trusted_Connection=False;"
    "CONNECTIONSTRINGS__DATAHUB_MSSQL_WEBANALYTICS"     = "Server=tcp:${var.sql_server_dns},1433;Database=${var.sql_database_webanalytics};Authentication=Active Directory Managed Identity;Encrypt=True;Trusted_Connection=False;"
    "CONNECTIONSTRINGS__DATAHUB_MSSQL_METADATA"         = "Server=tcp:${var.sql_server_dns},1433;Database=${var.sql_database_metadata};Authentication=Active Directory Managed Identity;Encrypt=True;Trusted_Connection=False;"
    "CONNECTIONSTRINGS__DATAHUB_MSSQL_FINANCE"          = "Server=tcp:${var.sql_server_dns},1433;Database=${var.sql_database_finance};Authentication=Active Directory Managed Identity;Encrypt=True;Trusted_Connection=False;"
    "CONNECTIONSTRINGS__DATAHUB_MSSQL_AUDIT"            = "Server=tcp:${var.sql_server_dns},1433;Database=${var.sql_database_audit};Authentication=Active Directory Managed Identity;Encrypt=True;Trusted_Connection=False;"
    "CONNECTIONSTRINGS__DATAHUB_MSSQL_LANGUAGETRAINING" = "Server=tcp:${var.sql_server_dns},1433;Database=${var.sql_database_training};Authentication=Active Directory Managed Identity;Encrypt=True;Trusted_Connection=False;"
    "CONNECTIONSTRINGS__DATAHUB_MSSQL_M365FORMS"        = "Server=tcp:${var.sql_server_dns},1433;Database=${var.sql_database_forms};Authentication=Active Directory Managed Identity;Encrypt=True;Trusted_Connection=False;"
    "WEBSITE_RUN_FROM_PACKAGE"                          = var.app_deploy_as_package
    "APPINSIGHTS_PROFILERFEATURE_VERSION"               = "disabled"
    "APPINSIGHTS_SNAPSHOTFEATURE_VERSION"               = "1.0.0"
    "DiagnosticServices_EXTENSION_VERSION"              = "~3"
    "SnapshotDebugger_EXTENSION_VERSION"                = "~1"
    "XDT_MicrosoftApplicationInsights_PreemptSdk"       = "disabled"
    "PowerBiTargets__SPI"                               = var.powerbi_url_spi
    "Graph__BaseUrl"                                    = "https://graph.microsoft.com/v1.0"
    "Graph__Scopes"                                     = "user.read"
    "EmailNotification__SmtpHost"                       = var.smtp_host
    "EmailNotification__SmtpPort"                       = var.smtp_port
    "EmailNotification__SmtpUsername"                   = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_smtp_username})"
    "EmailNotification__SmtpPassword"                   = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_smtp_password})"
    "EmailNotification__SenderName"                     = var.smtp_sender_name
    "EmailNotification__SenderAddress"                  = var.smtp_sender_address
    "EmailNotification__DevTestMode"                    = "false"
    "EmailNotification__AppDomain"                      = "https://${local.app_service_name}.azurewebsites.net/"
    "EmailNotification__TeamContactEmail"               = var.team_contact_email
    "PublicFileSharing__PublicFileSharingDomain"        = "${var.azure_dns_record}.${var.azure_dns_zone_name}"
    "PublicFileSharing__OpenDataApprovalPdfBaseUrl"     = var.powerbi_pdf_base_url
    "DeepL__UseFreeApi"                                 = "true"
    "DeepL__AuthKey"                                    = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_deepl_key})"
    "datahub_tenant_id"                                 = var.az_tenant_id

    "Achievements__Enabled"                          = var.enable_achievements
    "DesktopFileUploader__DisplayDesktopUploaderTab" = var.desktop_uploader_display_tab
    "ReverseProxy__Enabled"                          = var.reverse_proxy_enabled
    "ReverseProxy__MatchPath"                        = var.reverse_proxy_path
    "CkanConfiguration__Enabled"                     = var.ckan_enabled
    "CkanConfiguration__BaseUrl"                     = var.ckan_baseurl

    "DatahubGraphInviteFunctionUrl" = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_graph_user_create_url})"

    "DatahubServiceBus__ConnectionString" = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${var.service_bus_connection_string_secret_name})"

    "DatahubStorageQueue__ConnectionString"               = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_datahub_storage_queue_conn_str})"
    "Media__StorageConnectionString"                      = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_datahub_media_conn_str})"
    "DatahubGraphUsersStatusFunctionUrl"                  = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_graph_user_status_url})"
    "DatahubStorageQueue__QueueNames__ResourceRunRequest" = "resource-run-request"
    "DatahubStorageQueue__QueueNames__EmailNotification"  = "email-notifications"
    "DatahubStorageQueue__QueueNames__StorageCapacity"    = "storage-capacity"
    "DatahubStorageQueue__QueueNames__TerraformOutput"    = "terraform-output"

    "DefaultProjectBudget" = local.default_project_budget
    "AdoOrg__OrgName"      = var.ado_org_name
    "AdoOrg__ProjectName"  = var.ado_project_name

  }

  backup {
    name                = "datahub-backup-appservice"
    enabled             = true
    storage_account_url = "${data.azurerm_storage_account.datahub_storageaccount.primary_blob_endpoint}${var.global_var.config_name.container_backup}${data.azurerm_storage_account_blob_container_sas.datahub_backup_sas.sas}"
    schedule {
      frequency_interval       = "1"
      frequency_unit           = "Day"
      retention_period_days    = "32"
      keep_at_least_one_backup = true
    }
  }

  logs {
    application_logs {
      azure_blob_storage {
        level             = "Information"
        retention_in_days = 3660
        sas_url           = "${data.azurerm_storage_account.datahub_storageaccount.primary_blob_endpoint}${var.global_var.config_name.container_log}${data.azurerm_storage_account_blob_container_sas.datahub_app_log_sas.sas}"
      }
      file_system_level = "Information"
    }

    http_logs {
      azure_blob_storage {
        retention_in_days = 180
        sas_url           = "${data.azurerm_storage_account.datahub_storageaccount.primary_blob_endpoint}${var.global_var.config_name.container_log}${data.azurerm_storage_account_blob_container_sas.datahub_app_log_sas.sas}"
      }
    }

    #detailed_error_messages_enabled = true
    #failed_request_tracing_enabled  = true
  }

  tags = merge(
    var.common_tags
  )

  lifecycle {
    ignore_changes = [
      virtual_network_subnet_id,
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
      app_settings["PortalVersion__BuildId"],
      app_settings["PortalVersion__Commit"],
      app_settings["PortalVersion__Release"],
      app_settings["WEBSITE_ENABLE_SYNC_UPDATE_SITE"],
    ]
  }
}

resource "azurerm_linux_web_app_slot" "datahub_portal_app_service_slot" {
  count = var.app_create_slot ? 1 : 0

  name           = "stage"
  app_service_id = azurerm_linux_web_app.datahub_portal_app_service.id

  site_config {
    always_on              = var.app_service_always_on
    vnet_route_all_enabled = true
    websockets_enabled     = true
    http2_enabled          = true
    application_stack {
      dotnet_version = "8.0"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "HostingProfile"                                  = "ssc"
    "ApplicationInsightsAgent_EXTENSION_VERSION"      = "~2"
    "XDT_MicrosoftApplicationInsights_Mode"           = "recommended"
    "InstrumentationEngine_EXTENSION_VERSION"         = "~1"
    "XDT_MicrosoftApplicationInsights_BaseExtensions" = "~1"

    "ApplicationInsights__ConnectionString" = var.app_insights_str
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = var.app_insights_key

    "AzureAd__ClientId"                = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_client_id})"
    "AzureAd__ClientSecret"            = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_client_secret})"
    "AzureAd__TenantId"                = var.az_tenant_id
    "AzureAd__Domain"                  = var.aad_domain
    "AzureAd__AppIDURL"                = "https://${local.app_service_name}.azurewebsites.net/"
    "AzureAd__Instance"                = "https://login.microsoftonline.com/"
    "APITargets__StorageURL"           = "https://${var.storage_account_name}.blob.core.windows.net/datahub-fsdh"
    "APITargets__SearchServiceName"    = var.search_service_name
    "APITargets__StorageAccountName"   = var.datalake_storage_account_name
    "APITargets__KeyVaultName"         = var.key_vault_name
    "APITargets__LoginUrl"             = "https://AzureAD/Account/SignIn"
    "APITargets__LogoutUrl"            = "https://${local.app_service_name}.azurewebsites.net/"
    "APITargets__FileSystemName"       = var.datahub_filesystem
    "AZURE_TENANT_ID"                  = var.az_tenant_id
    "AZURE_CLIENT_ID"                  = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_client_id})"
    "AZURE_CLIENT_SECRET"              = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_client_secret})"
    "DataHub_ENVNAME"                  = var.environment_name
    "LOG_EXCEPTIONS"                   = "false"
    "ASPNETCORE_DETAILEDERRORS"        = "false"
    "ASPNETCORE_ENVIRONMENT"           = var.environment_name
    "Azure__SignalR__StickyServerMode" = "Required"
    "Azure__SignalR__ConnectionString" = azurerm_signalr_service.datahub_signalr.primary_connection_string

    "CONNECTIONSTRINGS__DATAHUB_MSSQL_PROJECT"          = "Server=tcp:${var.sql_server_dns},1433;Database=${var.sql_database_project};Authentication=Active Directory Managed Identity;Encrypt=True;Trusted_Connection=False;"
    "CONNECTIONSTRINGS__DATAHUB_MSSQL_PIP"              = "Server=tcp:${var.sql_server_dns},1433;Database=${var.sql_database_pip};Authentication=Active Directory Managed Identity;Encrypt=True;Trusted_Connection=False;"
    "CONNECTIONSTRINGS__DATAHUB_MSSQL_ETLDB"            = "Server=tcp:${var.sql_server_dns},1433;Database=${var.sql_database_etl};Authentication=Active Directory Managed Identity;Encrypt=True;Trusted_Connection=False;"
    "CONNECTIONSTRINGS__DATAHUB_MSSQL_WEBANALYTICS"     = "Server=tcp:${var.sql_server_dns},1433;Database=${var.sql_database_webanalytics};Authentication=Active Directory Managed Identity;Encrypt=True;Trusted_Connection=False;"
    "CONNECTIONSTRINGS__DATAHUB_MSSQL_METADATA"         = "Server=tcp:${var.sql_server_dns},1433;Database=${var.sql_database_metadata};Authentication=Active Directory Managed Identity;Encrypt=True;Trusted_Connection=False;"
    "CONNECTIONSTRINGS__DATAHUB_MSSQL_FINANCE"          = "Server=tcp:${var.sql_server_dns},1433;Database=${var.sql_database_finance};Authentication=Active Directory Managed Identity;Encrypt=True;Trusted_Connection=False;"
    "CONNECTIONSTRINGS__DATAHUB_MSSQL_AUDIT"            = "Server=tcp:${var.sql_server_dns},1433;Database=${var.sql_database_audit};Authentication=Active Directory Managed Identity;Encrypt=True;Trusted_Connection=False;"
    "CONNECTIONSTRINGS__DATAHUB_MSSQL_LANGUAGETRAINING" = "Server=tcp:${var.sql_server_dns},1433;Database=${var.sql_database_training};Authentication=Active Directory Managed Identity;Encrypt=True;Trusted_Connection=False;"
    "CONNECTIONSTRINGS__DATAHUB_MSSQL_M365FORMS"        = "Server=tcp:${var.sql_server_dns},1433;Database=${var.sql_database_forms};Authentication=Active Directory Managed Identity;Encrypt=True;Trusted_Connection=False;"
    "WEBSITE_RUN_FROM_PACKAGE"                          = var.app_deploy_as_package
    "APPINSIGHTS_PROFILERFEATURE_VERSION"               = "disabled"
    "APPINSIGHTS_SNAPSHOTFEATURE_VERSION"               = "1.0.0"
    "DiagnosticServices_EXTENSION_VERSION"              = "~3"
    "SnapshotDebugger_EXTENSION_VERSION"                = "~1"
    "XDT_MicrosoftApplicationInsights_PreemptSdk"       = "disabled"
    "PowerBiTargets__SPI"                               = var.powerbi_url_spi
    "Graph__BaseUrl"                                    = "https://graph.microsoft.com/v1.0"
    "Graph__Scopes"                                     = "user.read"
    "EmailNotification__SmtpHost"                       = var.smtp_host
    "EmailNotification__SmtpPort"                       = var.smtp_port
    "EmailNotification__SmtpUsername"                   = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_smtp_username})"
    "EmailNotification__SmtpPassword"                   = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_smtp_password})"
    "EmailNotification__SenderName"                     = var.smtp_sender_name
    "EmailNotification__SenderAddress"                  = var.smtp_sender_address
    "EmailNotification__DevTestMode"                    = "false"
    "EmailNotification__AppDomain"                      = "https://${local.app_service_name}.azurewebsites.net/"
    "EmailNotification__TeamContactEmail"               = var.team_contact_email
    "PublicFileSharing__PublicFileSharingDomain"        = "${var.azure_dns_record}.${var.azure_dns_zone_name}"
    "PublicFileSharing__OpenDataApprovalPdfBaseUrl"     = var.powerbi_pdf_base_url
    "DeepL__UseFreeApi"                                 = "true"
    "DeepL__AuthKey"                                    = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_deepl_key})"
    "datahub_tenant_id"                                 = var.az_tenant_id

    "Achievements__Enabled" = var.enable_achievements

    "ReverseProxy__Enabled"      = var.reverse_proxy_enabled
    "ReverseProxy__MatchPath"    = var.reverse_proxy_path
    "CkanConfiguration__Enabled" = var.ckan_enabled
    "CkanConfiguration__BaseUrl" = var.ckan_baseurl

    "DatahubServiceBus__ConnectionString" = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${var.service_bus_connection_string_secret_name})"

    "DatahubGraphInviteFunctionUrl"                       = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_graph_user_create_url})"
    "DatahubStorageQueue__ConnectionString"               = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_datahub_storage_queue_conn_str})"
    "Media__StorageConnectionString"                      = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_datahub_media_conn_str})"
    "DatahubGraphUsersStatusFunctionUrl"                  = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${local.secret_name_graph_user_status_url})"
    "DatahubStorageQueue__QueueNames__ResourceRunRequest" = "resource-run-request"
    "DatahubStorageQueue__QueueNames__EmailNotification"  = "email-notifications"
    "DatahubStorageQueue__QueueNames__StorageCapacity"    = "storage-capacity"
    "DatahubStorageQueue__QueueNames__TerraformOutput"    = "terraform-output"

    "DefaultProjectBudget" = local.default_project_budget
  }

  logs {
    application_logs {
      azure_blob_storage {
        level             = "Verbose"
        retention_in_days = 3660
        sas_url           = "${data.azurerm_storage_account.datahub_storageaccount.primary_blob_endpoint}${var.global_var.config_name.container_log}${data.azurerm_storage_account_blob_container_sas.datahub_app_log_sas.sas}"
      }

      file_system_level = "Information"
    }

    http_logs {
      azure_blob_storage {
        retention_in_days = 180
        sas_url           = "${data.azurerm_storage_account.datahub_storageaccount.primary_blob_endpoint}${var.global_var.config_name.container_log}${data.azurerm_storage_account_blob_container_sas.datahub_app_log_sas.sas}"
      }
    }
  }

  tags = merge(
    var.common_tags
  )

  lifecycle {
    ignore_changes = [
      virtual_network_subnet_id,
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
      app_settings["PortalVersion__BuildId"],
      app_settings["PortalVersion__Commit"],
      app_settings["PortalVersion__Release"],
      app_settings["WEBSITE_ENABLE_SYNC_UPDATE_SITE"],
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "log_appservice" {
  name                       = "spdatahub-log-appservice"
  target_resource_id         = azurerm_linux_web_app.datahub_portal_app_service.id
  log_analytics_workspace_id = var.log_workspace_id
  storage_account_id         = var.storage_account_id

  enabled_log {
    category = "AppServiceHTTPLogs"
  }

  enabled_log {
    category = "AppServiceConsoleLogs"
  }

  enabled_log {
    category = "AppServiceAppLogs"
  }

  enabled_log {
    category = "AppServiceAuditLogs"
  }

  enabled_log {
    category = "AppServicePlatformLogs"
  }

  metric {
    category = "AllMetrics"
  }
}
