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

variable "key_vault_id" {
  description = "Key vault ID"
  type        = string
}

variable "aad_group_dba_name" {
  description = "AAD Group Name for application DBA"
  type        = string
}

variable "aad_group_dba_oid" {
  description = "AAD Group oID for application DBA"
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

variable "sql_database_audit" {
  description = "The database name for audit database"
  type        = string
  default     = "dh-portal-audit"
}

variable "log_analytics_workspace_name" {
  description = "Log analytics workspace name"
  type        = string
}

variable "backup_vault_name" {
  description = "Backup Vault name for the solution"
  type        = string
}

variable "key_vault_cmk_name" {
  description = "Datahub main CMK name"
  type        = string
}






