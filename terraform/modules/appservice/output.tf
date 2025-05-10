output "datahub_portal_app_service_plan" {
  value = azurerm_service_plan.datahub_portal_app_service_plan.id
}

output "datahub_portal_app_service_plan_name" {
  value = azurerm_service_plan.datahub_portal_app_service_plan.name
}

output "datahub_portal_app_service_plan_sku" {
  value = azurerm_service_plan.datahub_portal_app_service_plan.sku_name
}

output "function_app_dotnet_id" {
  value = azurerm_linux_function_app.datahub_function_dotnet.id
}

output "function_ps_app_id" {
  value = azurerm_linux_function_app.datahub_function_ps.id
}

output "function_ps_secure_id" {
  value = azurerm_linux_function_app.datahub_function_ps_secure.id
}

output "app_service_name" {
  value = azurerm_linux_web_app.datahub_portal_app_service.name
}

output "function_app_name" {
  value = azurerm_linux_function_app.datahub_function_dotnet.name
}

output "function_app_res_prov_name" {
  value = azurerm_linux_function_app.res_prov_function_dotnet.name
}

output "function_app_py_name" {
  value = azurerm_linux_function_app.datahub_function_py.name
}

output "app_service_id" {
  value = azurerm_linux_web_app.datahub_portal_app_service.id
}

output "app_service_slot_name" {
  value = var.app_create_slot ? "${azurerm_linux_web_app.datahub_portal_app_service.name}/slots/${azurerm_linux_web_app_slot.datahub_portal_app_service_slot[0].name}" : ""
}

output "signalr_connection_string" {
  value = azurerm_signalr_service.datahub_signalr.primary_connection_string
}
