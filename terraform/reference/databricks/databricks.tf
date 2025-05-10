resource "azurerm_databricks_workspace" "datahub_databricks_main" {
  name                = local.databricks_name
  location            = data.azurerm_resource_group.datahub_rg.location
  resource_group_name = data.azurerm_resource_group.datahub_rg.name
  sku                 = "premium"

  tags = merge(
    var.common_tags
  )
}

provider "databricks" {
  azure_workspace_resource_id = azurerm_databricks_workspace.datahub_databricks_main.id
  azure_use_msi               = var.azure_use_msi
}

data "databricks_node_type" "smallest" {
  local_disk    = true
  min_cores     = 2
  min_memory_gb = 8
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true

  depends_on = [azurerm_databricks_workspace.datahub_databricks_main]
}

resource "databricks_cluster" "datahub_shared_autoscaling" {
  cluster_name            = local.databricks_cluster_name
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 15
  autoscale {
    min_workers = 1
    max_workers = 8
  }
}

data "azurerm_key_vault_secret" "datahub_devops_service_principal" {
  name         = "datahub-devops-sp"
  key_vault_id = data.azurerm_key_vault.datahub_key_vault.id
}

resource "databricks_user" "datahub_dbs_users_main_ws" {
  user_name = "simon.wang@datalio.com"
}

data "databricks_group" "admins" {
  display_name = "admins"
}

resource "databricks_service_principal" "sp" {
  application_id = data.azurerm_key_vault_secret.datahub_devops_service_principal.value
}

resource "databricks_group_member" "i-am-admin" {
  group_id  = data.databricks_group.admins.id
  member_id = databricks_service_principal.sp.id
}
