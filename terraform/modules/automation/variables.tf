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

variable "az_subscription_id" {
  description = "Azure subscription ID"
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

variable "app_service_plan_name" {
  description = "The name of the app service plan for DataHub core app"
  type        = string
}

variable "app_service_plan_id" {
  description = "The ID of the app service plan for DataHub core app"
  type        = string
}

variable "app_service_plan_sku_normal" {
  description = "The SKU name of the normal app service plan for DataHub core app"
  type        = string
}

variable "app_service_plan_sku_down" {
  description = "The scaled down SKU name of the app service plan for DataHub core app"
  type        = string
  default     = ""
}

variable "key_vault_id" {
  description = "Key vault ID"
  type        = string
}

