output "mssql_dns" {
  value = azurerm_mssql_server.datahub_sql_server.fully_qualified_domain_name
}

output "mssql_id" {
  value = azurerm_mssql_server.datahub_sql_server.id
}

output "mssql_name" {
  value = azurerm_mssql_server.datahub_sql_server.name
}

output "mssql_db_name_project" {
  value = local.sql_database_project
}

output "mssql_db_name_pip" {
  value = local.sql_database_pip
}

output "mssql_db_name_etl" {
  value = local.sql_database_etl
}

output "mssql_db_name_webanalytics" {
  value = local.sql_database_webanalytics
}

output "mssql_db_name_metadata" {
  value = local.sql_database_metadata
}

output "mssql_db_name_audit" {
  value = local.sql_database_audit
}

output "mssql_db_name_finance" {
  value = local.sql_database_finance
}

output "mssql_db_name_training" {
  value = local.sql_database_training
}

output "mssql_db_name_forms" {
  value = local.sql_database_forms
}
