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

variable "common_tags" {
  description = "Common tags map"
  type        = map(any)
}

variable "resource_prefix" {
  description = "Resource name prefix for all resources in this project"
  type        = string
}

variable "log_sku" {
  description = "SKU for log analytics workspace"
  type        = string
  default     = "PerGB2018"
}

variable "alert_email_address" {
  description = "Email address for notification"
  type        = string
}

variable "alerts_count_trigger_email" {
  description = "Number of exceptions in the last 6 hours to trigger email"
  type        = number
  default     = 6
}

variable "send_alert_email" {
  description = "Send alert email from App Insight in case of errors"
  type        = bool
  default     = false
}

variable "log_retention_days" {
  description = "Number of days logs are kept"
  type        = number
  default     = 365
}

variable "log_workspace_id" {
  description = "The object ID of the pre-existing centrally managed Azure Log Analytics Workspace"
  type        = string
}
