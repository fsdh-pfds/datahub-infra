output "app_config_id" {
  value = azurerm_app_configuration.datahub_app_config.id
}

output "app_config_endpoint" {
  value = azurerm_app_configuration.datahub_app_config.endpoint
}

output "app_config_keys" {
  value = var.global_var.config_name
}

