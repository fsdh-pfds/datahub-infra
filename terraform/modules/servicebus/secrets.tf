resource "azurerm_key_vault_secret" "service_bus_connection_string" {
    name         = local.service_bus_secret_name
    value        = azurerm_servicebus_namespace.datahub_service_bus.default_primary_connection_string
    key_vault_id = var.key_vault_id
}