output "datalake_storage_account_name" {
  value = azurerm_storage_account.datalake_gen2.name
}

output "datalake_storage_url" {
  value = azurerm_storage_account.datalake_gen2.primary_blob_endpoint
}

output "datalake_storage_id" {
  value = azurerm_storage_account.datalake_gen2.id
}

output "datahub_filesystem_name" {
  value = azurerm_storage_data_lake_gen2_filesystem.datahub_gen2.name
}
