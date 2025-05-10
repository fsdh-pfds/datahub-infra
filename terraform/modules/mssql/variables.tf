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

variable "key_vault_cmk_name" {
  description = "Datahub main CMK name"
  type        = string
}

variable "key_vault_cmk_id" {
  description = "Datahub main CMK"
  type        = string
}

variable "aad_group_dba_oid" {
  description = "AAD Group OID for application DBA"
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

variable "app_service_name" {
  description = "Datahub app service name"
  type        = string
}

variable "app_create_slot" {
  description = "if Datahub app service has slot"
  type        = bool
}

variable "app_service_slot_name" {
  description = "Datahub app slot service name"
  type        = string
}

variable "function_app_name" {
  description = "Datahub function app name to grant database access"
  type        = string
}

variable "function_app_name_res_prov" {
  description = "Datahub function app name (resource provisioner) to grant database access"
  type        = string
}
