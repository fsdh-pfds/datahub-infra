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

variable "environment_name" {
  description = "Environment code"
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

variable "app_deploy_as_package" {
  description = "Indicate if the app is deployed as a packaged app"
  type        = string
  default     = "0"
}

variable "key_vault_name" {
  description = "Main key vault name"
  type        = string
}

variable "key_vault_id" {
  description = "Key vault ID"
  type        = string
}

variable "key_vault_cmk_name" {
  description = "Datahub main CMK name"
  type        = string
}

variable "log_container" {
  description = "Base PowerBI URL for approving PDF in GC Open Data"
  type        = string
  default     = "datahub-app-log"
}

variable "log_workspace_id" {
  description = "The object ID of the pre-existing centrally managed Azure Log Analytics Workspace"
  type        = string
}

variable "enforce_log_immunity" {
  description = "Indicate if the datahub-app-log container is protected from deletion by creating time-based rention policy"
  type        = bool
  default     = false
}


