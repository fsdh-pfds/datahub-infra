data "azurerm_client_config" "current" {}

locals {
  blob_storage_account_name  = lower("${var.resource_prefix}storage${var.environment_name}")
  blob_storage_acct_name_pub = lower("${var.resource_prefix}storage${var.environment_name}pub")
  blob_container_name_pub    = "datahub-dist"
  blob_tfbackend_name        = lower("${var.resource_prefix}${var.environment_name}terraformbackend")
}
