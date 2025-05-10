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

variable "key_vault_id" {
  description = "Key vault ID"
  type        = string
}

variable "git_version_url" { default = "-" }
variable "git_branch_name" { default = "-" }
