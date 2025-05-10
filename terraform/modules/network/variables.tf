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

variable "app_service_id" {
  description = "Datahub app service name"
  type        = string
}

variable "app_service_name" {
  description = "Datahub app service name"
  type        = string
}

variable "function_app_name" {
  description = "Datahub app service name"
  type        = string
}

variable "function_app_name_res_prov" {
  description = "Datahub app service name for resource provisioner"
  type        = string
}

variable "function_app_name_py" {
  description = "Datahub app service name for user provisioner python"
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

variable "mssql_name" {
  description = "MS SQL Server name"
  type        = string
}

variable "mssql_id" {
  description = "MS SQL Server ID"
  type        = string
}

variable "storage_id" {
  description = "Main Blob storage resource ID"
  type        = string
}

variable "datalake_id" {
  description = "Main Datalake storage resource ID"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the main storage account (blob)"
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

variable "datahub_vnet_cidr" {
  description = "CIDR for the DataHub VNET"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_paz_cidr" {
  description = "CIDR for the PAZ Subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_oz_cidr" {
  description = "CIDR for the OZ Subnet"
  type        = string
  default     = "10.0.4.0/22"
}

variable "subnet_rz_cidr" {
  description = "CIDR for the RZ Subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "subnet_az_cidr" {
  description = "CIDR for the Azure App Service Subnet"
  type        = string
  default     = "10.0.2.192/26"
}

variable "subnet_dbr_pub_cidr" {
  description = "Address prefix for Databricks public subnet"
  type        = string
  default     = "10.0.8.0/25"
}

variable "subnet_dbr_prv_cidr" {
  description = "Address prefix for Databricks private subnet"
  type        = string
  default     = "10.0.8.128/25"
}
variable "azure_dns_record" {
  description = "DNS record to use with azure_dns_zone. App Services custom domain will be azure_dns_record.azure_dns_zone_name. "
  type        = string
  default     = ""
}

variable "azure_dns_zone_name" {
  description = "Azure DNS zone domain name that is used for app service custom domain. Empty string will void custom domain creation"
  type        = string
  default     = ""
}

variable "azure_dns_zone_rg" {
  description = "Resource group name for Azure DNS zone (optional)"
  type        = string
  default     = ""
}
