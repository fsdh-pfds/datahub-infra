data "azurerm_client_config" "current" {}

data "azurerm_storage_account" "datahub_storageaccount" {
  name                = var.storage_account_name
  resource_group_name = var.az_resource_group
}

# My public IP: data.http.myip.response_body
data "http" "myip" {
  url = "https://checkip.amazonaws.com"
}

locals {
  firewall_name_myip        = "allowFrom_myIP"
  sql_server_name           = "${var.resource_prefix}-portal-sql-${var.environment_name}"
  sql_pool_name             = "${var.resource_prefix}-sql-pool-${var.environment_name}"
  sql_username_admin        = "${var.resource_prefix}-portal-sqladmin"
  sql_username_readonly     = "${var.resource_prefix}-portal-sqlreadonly"
  sql_database_project      = "dh-portal-projectdb"
  sql_database_pip          = "dh-portal-pipdb"
  sql_database_etl          = "dh-portal-etldb"
  sql_database_webanalytics = "dh-portal-webanalytics"
  sql_database_metadata     = "dh-portal-metadata"
  sql_database_audit        = "dh-portal-audit"
  sql_database_finance      = "dh-portal-finance"
  sql_database_training     = "dh-portal-languagetraining"
  sql_database_forms        = "dh-portal-m365forms"
  sql_db_names = [
    "${azurerm_mssql_database.datahub_sqldb_project.name}",
    "${azurerm_mssql_database.datahub_sqldb_pip.name}",
    "${azurerm_mssql_database.datahub_sqldb_etl.name}",
    "${azurerm_mssql_database.datahub_sqldb_webanalytics.name}",
    "${azurerm_mssql_database.datahub_sqldb_metadata.name}",
    "${azurerm_mssql_database.datahub_sqldb_audit.name}",
    "${azurerm_mssql_database.datahub_sqldb_finance.name}",
    "${azurerm_mssql_database.datahub_sqldb_training.name}",
    "${azurerm_mssql_database.datahub_sqldb_forms.name}",
  ]
}
