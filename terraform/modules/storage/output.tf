output "blob_storage_account_name" {
  value = azurerm_storage_account.datahub_storageaccount.name
}

output "blobstorage_url" {
  value = azurerm_storage_account.datahub_storageaccount.primary_blob_endpoint
}

output "blobstorage_id" {
  value = azurerm_storage_account.datahub_storageaccount.id
}

output "queue_email_notification" {
  value = azurerm_storage_queue.email_notification.name
}

output "queue_project_usage_update" {
  value = azurerm_storage_queue.project_usage_update.name
}

output "queue_project_usage_notification" {
  value = azurerm_storage_queue.project_usage_notification.name
}

output "queue_project_capacity_update" {
  value = azurerm_storage_queue.project_capacity_update.name
}

output "queue_inactive_project_notification" {
  value = azurerm_storage_queue.inactive_project_notification.name
}

output "queue_inactive_user_notification" {
  value = azurerm_storage_queue.inactive_user_notification.name
}


