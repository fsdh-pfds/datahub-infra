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

variable "key_vault_name" {
  description = "Main key vault name"
  type        = string
}

variable "key_vault_cmk_name" {
  description = "Datahub main CMK name"
  type        = string
  default     = "datahub-main-cmk"
}

variable "key_vault_cmk_name_proj" {
  description = "Datahub CMK name for project"
  type        = string
  default     = "datahub-project-cmk"
}

variable "aad_group_admin_oid" {
  description = "AAD Group OID for applicaiton admin group"
  type        = string
}

variable "aad_group_dba_oid" {
  description = "AAD Group OID for applicaiton DBA"
  type        = string
}

variable "key_vault_id" {
  description = "Key vault ID"
  type        = string
}

variable "azure_databricks_sp" {
  description = "Service principal for Azure Databricks enterprise app"
  type        = string
}

variable "pr_auto_approver_oid" {
  description = "AAD OID for the auto approver of the Pull Requests (PR) in Azure DevOps Repo for project workspace resource provisioning"
  type        = string
  default     = ""
}
