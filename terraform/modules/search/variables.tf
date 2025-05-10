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
  description = "Main key vault name"
  type        = string
}

variable "aad_group_dba_name" {
  description = "AAD Group Name for application DBA"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the main storage account (blob)"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the main storage account (blob)"
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "Log analytics workspace name"
  type        = string
}

variable "backup_vault_name" {
  description = "Backup Vault name for the solution"
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

variable "datalake_storage_account_name" {
  description = "The name of the main datalake storage account (datalake gen2)"
  type        = string
}




