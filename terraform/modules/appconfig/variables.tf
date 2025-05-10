variable "environment_name" {
  description = "Environment code"
  type        = string
}

variable "az_resource_group" {
  description = "Azure resource group name"
  type        = string
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
  type        = map(any)
}

variable "resource_prefix" {
  description = "Resource name prefix for all resources in this project"
  type        = string
}

variable "key_vault_name" {
  description = "Key vault name"
  type        = string
}

variable "key_vault_id" {
  description = "Key vault ID"
  type        = string
}

variable "key_vault_cmk_id" {
  description = "Datahub main CMK ID"
  type        = string
}

variable "aad_group_admin_oid" {
  description = "AAD Group OID for applicaiton admin"
  type        = string
}

variable "log_workspace_id" {
  description = "The object ID of the pre-existing centrally managed Azure Log Analytics Workspace"
  type        = string
}

variable "app_insights_key" {
  description = "Instrumentation key for Application Insights"
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

variable "global_var" {
  description = "Global variables"
  type        = map(any)
}