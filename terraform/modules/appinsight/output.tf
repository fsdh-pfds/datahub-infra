output "app_insights_key" {
  value = azurerm_application_insights.datahub_appinsight_app.instrumentation_key
}

output "app_insights_str" {
  value = azurerm_application_insights.datahub_appinsight_app.connection_string
}

output "app_insights_str_func" {
  value = azurerm_application_insights.datahub_appinsight_function.connection_string
}

output "app_insights_str_func_res_prov" {
  value = azurerm_application_insights.datahub_appinsight_function_res_prov.connection_string
}

output "app_insights_str_func_py" {
  value = azurerm_application_insights.datahub_appinsight_function_py.connection_string
}
