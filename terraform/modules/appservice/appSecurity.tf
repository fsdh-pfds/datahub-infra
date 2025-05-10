resource "azurerm_key_vault_secret" "secret_func_create_graph_user_url" {
  name         = local.secret_name_graph_user_create_url
  value        = "https://${azurerm_linux_function_app.datahub_function_dotnet.default_hostname}/api/CreateGraphUser?code=${data.azurerm_function_app_host_keys.datahub_function_dotnet_host_keys.default_function_key}"
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "secret_func_status_graph_user_url" {
  name         = local.secret_name_graph_user_status_url
  value        = "https://${azurerm_linux_function_app.datahub_function_dotnet.default_hostname}/api/GetUsersStatus?code=${data.azurerm_function_app_host_keys.datahub_function_dotnet_host_keys.default_function_key}"
  key_vault_id = var.key_vault_id
}

resource "azurerm_role_assignment" "kv_role_app_registration" {
  for_each = local.kv_user_roles

  scope                = var.key_vault_id
  principal_id         = data.azurerm_key_vault_secret.secret_client_oid.value
  role_definition_name = each.key
}

resource "azurerm_role_assignment" "kv_role_app_datahub_app" {
  for_each = local.kv_user_roles

  scope                = var.key_vault_id
  principal_id         = azurerm_linux_web_app.datahub_portal_app_service.identity.0.principal_id
  role_definition_name = each.key
}

resource "azurerm_role_assignment" "kv_role_app_datahub_app_slot" {
  for_each = local.kv_user_roles

  scope                = var.key_vault_id
  principal_id         = azurerm_linux_web_app_slot.datahub_portal_app_service_slot[0].identity.0.principal_id
  role_definition_name = each.key
}

resource "azurerm_role_assignment" "kv_role_app_func_app_res_prov" {
  for_each = local.kv_user_roles

  scope                = var.key_vault_id
  principal_id         = azurerm_linux_function_app.res_prov_function_dotnet.identity[0].principal_id
  role_definition_name = each.key
}

data "azurerm_function_app_host_keys" "function_ps_key" {
  name                = azurerm_linux_function_app.datahub_function_ps.name
  resource_group_name = var.az_resource_group
}

data "azurerm_function_app_host_keys" "function_ps_secure_key" {
  name                = azurerm_linux_function_app.datahub_function_ps.name
  resource_group_name = var.az_resource_group
}

data "azurerm_function_app_host_keys" "datahub_function_dotnet_host_keys" {
  name                = azurerm_linux_function_app.datahub_function_dotnet.name
  resource_group_name = var.az_resource_group
}

resource "azurerm_role_assignment" "blob_datahub_app_role" {
  scope                = data.azurerm_storage_account.datahub_storageaccount.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_web_app.datahub_portal_app_service.identity.0.principal_id
}

resource "azurerm_role_assignment" "blob_function_res_prov_role" {
  scope                = data.azurerm_storage_account.datahub_storageaccount.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_function_app.res_prov_function_dotnet.identity.0.principal_id
}

resource "azurerm_role_assignment" "blob_function_dotnet_role" {
  scope                = data.azurerm_storage_account.datahub_storageaccount.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_function_app.datahub_function_dotnet.identity.0.principal_id
}

resource "azurerm_role_assignment" "datahub_app_log_stream" {
  scope                = azurerm_linux_web_app.datahub_portal_app_service.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_key_vault_secret.secret_client_oid.value
}
