data "azurerm_client_config" "current" {}
data "azurerm_resource_group" "datahub_rg" { name = var.az_resource_group }

data "azurerm_storage_account" "datahub_storageaccount" {
  name                = var.storage_account_name
  resource_group_name = data.azurerm_resource_group.datahub_rg.name
}

data "azurerm_log_analytics_workspace" "datahub_log" {
  name                = var.log_analytics_workspace_name
  resource_group_name = data.azurerm_resource_group.datahub_rg.name
}

data "azurerm_key_vault" "datahub_key_vault" {
  name                = var.key_vault_name
  resource_group_name = data.azurerm_resource_group.datahub_rg.name
}

locals {
  databricks_name         = "${var.resource_prefix}-databricks-${var.environment_name}"
  databricks_cluster_name = "${var.resource_prefix}-databricks-shared-cluster-${var.environment_name}"
}
