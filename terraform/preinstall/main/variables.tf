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

variable "az_tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "resource_prefix" {
  description = "Resource name prefix for all resources"
  type        = string
}

variable "support_email" {
  description = "Email of the system owner"
  type        = string
}
