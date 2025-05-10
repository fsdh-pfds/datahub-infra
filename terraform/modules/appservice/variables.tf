#-----------------------------------#
#           Environment
#-----------------------------------#
variable "environment_name" {
  description = "Environment code"
  type        = string
}

variable "environment_classification" {
  description = "Environment classification"
  type        = string
  default     = "U"
}

variable "az_region" {
  description = "Azure resource group regsion"
  type        = string
  default     = "canadacentral"
}

variable "az_tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "common_tags" {
  description = "Common tags map"
  type        = map(string)
}

variable "resource_prefix" {
  description = "Resource name prefix for all resources in this project"
  type        = string
}

variable "az_subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "ws_subscription_id" {
  description = "Workspace subscription ID"
  type        = string
}

#-----------------------------------#
#             Other
#-----------------------------------#
variable "app_service_alert_count_6h" {
  description = "Number of alerts in 6h to trigger email"
  type        = string
  default     = "32"
}

variable "app_service_always_on" {
  description = "Number of alerts in 6h to trigger email"
  type        = string
  default     = "false"
}

variable "app_service_workers" {
  description = "Number of workers for the app service"
  type        = number
  default     = 1
}

variable "app_service_sku" {
  description = "App service tier"
  type        = string
  default     = "S2"
}

variable "az_resource_group" {
  description = "Azure resource group name"
  type        = string
}

variable "app_insights_key" {
  description = "Connection string for Application Insights"
  type        = string
}

variable "app_insights_str" {
  description = "Connection string for Application Insights"
  type        = string
}

variable "app_insights_str_func" {
  description = "Connection string for Application Insights"
  type        = string
}

variable "app_insights_str_func_res_prov" {
  description = "Connection string for Application Insights"
  type        = string
}

variable "app_insights_str_func_py" {
  description = "Connection string for Application Insights"
  type        = string
}

variable "app_deploy_as_package" {
  description = "Indicate if the app is deployed as a packaged app"
  type        = string
  default     = "0"
}

variable "app_create_slot" {
  description = "Indicate if the stage slot should be created"
  type        = bool
  default     = true
}

variable "key_vault_name" {
  description = "Main key vault name"
  type        = string
}

variable "key_vault_id" {
  description = "Key vault ID"
  type        = string
}

variable "key_vault_uri" {
  description = "Main key vault uri"
  type        = string
}

variable "aad_domain" {
  description = "AAD domain name"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the main storage account (blob)"
  type        = string
}

variable "storage_account_id" {
  description = "The ID of the main storage account (blob)"
  type        = string
}

variable "datalake_storage_account_name" {
  description = "The name of the main datalake storage account (datalake gen2)"
  type        = string
}

variable "search_service_name" {
  description = "The name of the Azure Search"
  type        = string
}

variable "sql_server_dns" {
  description = "The FQDN of the Azure MS SQL server"
  type        = string
}

variable "sql_database_project" {
  description = "The database name for project database"
  type        = string
  default     = "dh-portal-projectdb"
}

variable "sql_database_pip" {
  description = "The database name for pip database"
  type        = string
  default     = "dh-portal-pipdb"
}

variable "sql_database_etl" {
  description = "The database name for etl database"
  type        = string
  default     = "dh-portal-etldb"
}

variable "sql_database_webanalytics" {
  description = "The database name for web analytics database"
  type        = string
  default     = "dh-portal-webanalytics"
}

variable "sql_database_metadata" {
  description = "The database name for metadata database"
  type        = string
  default     = "dh-portal-metadata"
}

variable "sql_database_finance" {
  description = "The database name for finance database"
  type        = string
  default     = "dh-portal-finance"
}

variable "sql_database_audit" {
  description = "The database name for finance database"
  type        = string
  default     = "dh-portal-audit"
}

variable "sql_database_training" {
  description = "The database name for finance database"
  type        = string
  default     = "dh-portal-languagetraining"
}

variable "sql_database_forms" {
  description = "The database name for finance database"
  type        = string
  default     = "dh-portal-m365forms"
}

variable "powerbi_url_spi" {
  description = "PowerBI URL for SPI"
  type        = string
}

variable "smtp_host" {
  description = "SMTP Server host name"
  type        = string
  default     = "email-smtp.ca-central-1.amazonaws.com"
}

variable "smtp_port" {
  description = "SMTP server port number"
  type        = number
  default     = 587
}

variable "smtp_sender_name" {
  description = "SMTP sender display name"
  type        = string
}

variable "smtp_sender_address" {
  description = "SMTP sender email address"
  type        = string
}

variable "team_contact_email" {
  description = "Generic email address for FSDH team contact"
  type        = string
}

variable "powerbi_pdf_base_url" {
  description = "Base PowerBI URL for approving PDF in GC Open Data"
  type        = string
}

variable "log_container" {
  description = "Base PowerBI URL for approving PDF in GC Open Data"
  type        = string
  default     = "datahub-app-log"
}

variable "datahub_filesystem" {
  description = "Datahub container name"
  type        = string
  default     = "datahub"
}

variable "default_user_group" {
  description = "Datahub user default group ID"
  type        = string
}

variable "log_workspace_id" {
  description = "The object ID of the pre-existing centrally managed Azure Log Analytics Workspace"
  type        = string
}

variable "azure_dns_record" {
  description = "DNS record to use with azure_dns_zone. App Services custom domain will be azure_dns_record.azure_dns_zone_name. "
  type        = string
  default     = ""
}

variable "azure_dns_zone_name" {
  description = "Azure DNS zone domain name that is used for app service custom domain. Empty string will void custom domain creation"
  type        = string
  default     = ""
}

variable "azure_dns_zone_rg" {
  description = "Resource group name for Azure DNS zone (optional)"
  type        = string
  default     = ""
}

variable "ssl_cert_name" {
  description = "KeyVault certificate name that was imported from PFX"
  type        = string
  default     = ""
}

variable "ssl_cert_kv_id" {
  description = "KeyVault ID hosting the SSL"
  type        = string
  default     = ""
}

variable "enable_achievements" {
  description = "Whether to enable achievements in the app"
  type        = string
  default     = "false"
}

variable "project_module_branch" {
  description = "Branch of the versioned modules for project resource modules used by resource provisioner"
  type        = string
}

variable "desktop_uploader_display_tab" {
  description = "control if the uploader tab is displayed"
  type        = string
}

variable "global_var" {
  description = "Global variables"
  type        = map(any)
}

variable "reverse_proxy_enabled" {
  description = "Enable the reverse proxy feature"
  type        = string
}

variable "reverse_proxy_path" {
  description = "The context root of the reverse proxy feature"
  type        = string
}

variable "ckan_enabled" {
  description = "Value for app setting CkanConfiguration__Enabled"
  type        = string
}

variable "ckan_baseurl" {
  description = "Value for app setting CkanConfiguration__BaseUrl"
  type        = string
}

variable "ckan_testmode" {
  description = "Value for app setting CkanConfiguration__TestMode"
  type        = string
}

variable "ado_org_name" {
  description = "Name of the ADO Org for creating support items"
  type        = string
}

variable "ado_project_name" {
  description = "Name of the ADO project"
  type        = string
}

#----------------------------------------#
#         Service Bus Connection String
#----------------------------------------#
variable "service_bus_connection_string_secret_name" {
  description = "Name of the secret in key vault for service bus connection string"
  type        = string
}

variable "project_automation_acct_uai_name" {
  description = "Project common UAMI for executing workspace related automation"
  type        = string
}

variable "project_automation_acct_uai_rg" {
  description = "Project common UAMI for executing workspace related automation"
  type        = string
}

variable "project_automation_acct_uai_sub" {
  description = "Project common UAMI for executing workspace related automation"
}

variable "bug_report_teams_webhook_url" {
  description = "Webhook URL for posting bug reports to Teams"
  type        = string
}