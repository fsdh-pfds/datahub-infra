variable "environment_name" {
  description = "Environment code"
  type        = string
}

variable "resource_prefix" {
  description = "Resource name prefix for all resources in this project"
  type        = string
}

variable "az_tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "common_tags" {
  description = "Common tags map"
  type        = map(any)
}
