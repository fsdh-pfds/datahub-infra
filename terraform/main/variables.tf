variable "environment_name" {
  description = "Environment code"
  type        = string
}

variable "environment_classification" {
  description = "Max level of security the environment hosts"
  type        = string
  default     = "PA"
}

variable "az_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "ws_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "az_resource_group" {
  description = "Azure Resource Group name"
  type        = string
}

variable "az_tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "aad_domain" {
  description = "AAD domain name"
  type        = string
}

variable "resource_prefix" {
  description = "Resource name prefix for all resources"
  type        = string
  default     = "fsdh"
}

variable "key_vault_name" {
  description = "Main key vault name"
  type        = string
}

variable "key_vault_id" {
  description = "Key vault ID"
  type        = string
}

variable "alert_email_address" {
  description = "Email of the system owner"
  type        = string
}

variable "contact_email" {
  description = "Email address of FSDH team"
  type        = string
}

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

variable "app_service_sku_down" {
  description = "App service tier to scale down"
  type        = string
  default     = ""
}

variable "app_create_slot" {
  description = "Indicate if the stage slot should be created"
  type        = bool
}

variable "aad_group_admin_name" {
  description = "AAD Group name for applicaiton admin"
  type        = string
}

variable "aad_group_admin_oid" {
  description = "AAD Group OID for applicaiton admin"
  type        = string
}

variable "aad_group_dba_name" {
  description = "AAD Group Name for application DBA"
  type        = string
}

variable "aad_group_dba_oid" {
  description = "AAD Group OID for applicaiton DBA"
  type        = string
}

variable "powerbi_url_spi" {
  description = "Power BI URL SPI"
  type        = string
}

variable "powerbi_pdf_base_url" {
  description = "Power BI base URL for PDF viewing"
  type        = string
}

variable "smtp_host" {
  description = "SMTP host"
  type        = string
  default     = "email-smtp.ca-central-1.amazonaws.com"
}

variable "smtp_port" {
  description = "SMTP port"
  type        = number
  default     = 587
}

variable "smtp_sender_name" {
  description = "SMTP sender name"
  type        = string
}

variable "smtp_sender_address" {
  description = "SMTP sender email address"
  type        = string
}

variable "opendata_approver_name" {
  description = "Approver display name for open data approver"
  type        = string
}

variable "opendata_approver_email" {
  description = "Approver email for open data approver"
  type        = string
}

variable "opendata_api_url" {
  description = "URL for open data API endpoint"
  type        = string
}

variable "azure_use_msi" {
  description = "For Databricks provider - if use MSI authentication (e.g. run from DevOps pipelines)"
  type        = bool
}

variable "send_alert_email" {
  description = "Send alert email from App Insight in case of errors"
  type        = bool
  default     = false
}

variable "azure_databricks_sp" {
  description = "Object ID for the AD Service principal for Azure Databricks enterprise app"
  type        = string
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

variable "pr_auto_approver_oid" {
  description = "AAD OID for the auto approver of the Pull Requests (PR) in Azure DevOps Repo for project workspace resource provisioning"
  type        = string
  default     = ""
}

variable "project_module_branch" {
  description = "Branch of the versioned modules for project resource modules used by resource provisioner"
  type        = string
  default     = "main"
}

variable "desktop_uploader_display_tab" {
  description = "control if the uploader tab is displayed"
  type        = string
  default     = "false"
}


variable "reverse_proxy_enabled" {
  description = "Enable the reverse proxy feature"
  type        = string
  default     = "true"
}

variable "reverse_proxy_path" {
  description = "The context root of the reverse proxy feature"
  type        = string
  default     = "/webapp"
}

variable "ckan_enabled" {
  description = "Value for app setting CkanConfiguration__Enabled"
  type        = string
  default     = "false"
}


variable "ckan_baseurl" {
  description = "Value for app setting CkanConfiguration__BaseUrl"
  type        = string
  default     = "https://registry.open.canada.ca/"
}

variable "ckan_testmode" {
  description = "Value for app setting CkanConfiguration__TestMode"
  type        = string
  default     = "false"
}

variable "ado_org_name" {
  description = "Name of the ADO Org for creating support items"
  type        = string
  default     = "DataSolutionsDonnees"
}

variable "ado_project_name" {
  description = "Name of the ADO project"
  type        = string
  default     = "FSDH%20SSC"
}

variable "bug_report_teams_webhook_url" {
  description = "Webhook URL for posting bug reports to Teams"
  type        = string
  default     = ""
}
