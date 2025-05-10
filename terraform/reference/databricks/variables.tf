variable "environment_name" {
  description = "Environment code"
  type        = string
}

variable "az_resource_group" {
  description = "Azure resource group name"
  type        = string
}

variable "common_tags" {
  description = "Common tags map"
  type        = map(any)
}

variable "key_vault_name" {
  description = "Main key vault name"
  type        = string
}

variable "resource_prefix" {
  description = "Resource name prefix for all resources in this project"
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "Log analytics workspace name"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the main storage account (blob)"
  type        = string
}

variable "azure_use_msi" {
  description = "For Databricks provider - if use MSI authentication (e.g. run from DevOps pipelines)"
  type        = bool
}
