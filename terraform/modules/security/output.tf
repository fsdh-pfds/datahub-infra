output "datahub_cmk_name" {
  value = azurerm_key_vault_key.datahub_cmk.name
}

output "datahub_cmk_id" {
  value = azurerm_key_vault_key.datahub_cmk.versionless_id
}

output "datahub_cmk_id_with_version" {
  value = "${azurerm_key_vault_key.datahub_cmk.versionless_id}/${azurerm_key_vault_key.datahub_cmk.version}"
}

output "datahub_project_cmk_name" {
  value = azurerm_key_vault_key.datahub_project_cmk.name
}

output "datahub_project_cmk_id" {
  value = azurerm_key_vault_key.datahub_project_cmk.versionless_id
}

output "key_vault_url" {
  value = data.azurerm_key_vault.datahub_key_vault.vault_uri
}
