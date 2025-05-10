resource "azurerm_storage_queue" "resource_run_request" {
  name                 = "resource-run-request"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
}

resource "azurerm_storage_queue" "resource_run_request_poison" {
  name                 = "resource-run-request-poison"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
}

resource "azurerm_storage_queue" "email_notification" {
  name                 = "email-notification"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
}

resource "azurerm_storage_queue" "email_notification_poison" {
  name                 = "email-notification-poison"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
}

resource "azurerm_storage_queue" "storage_capacity" {
  name                 = "storage-capacity"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
}

resource "azurerm_storage_queue" "terraform_output" {
  name                 = "terraform-output"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
}

resource "azurerm_storage_queue" "terraform_output_poison" {
  name                 = "terraform-output-poison"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
}

resource "azurerm_storage_queue" "project_usage_update" {
  name                 = "project-usage-update"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
}

resource "azurerm_storage_queue" "project_usage_update_poison" {
  name                 = "project-usage-update-poison"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
}

resource "azurerm_storage_queue" "project_usage_notification" {
  name                 = "project-usage-notification"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
}

resource "azurerm_storage_queue" "project_usage_notification_poison" {
  name                 = "project-usage-notification-poison"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
}

resource "azurerm_storage_queue" "project_capacity_update" {
  name                 = "project-capacity-update"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
}

resource "azurerm_storage_queue" "project_capacity_update_poison" {
  name                 = "project-capacity-update-poison"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
}

resource "azurerm_storage_queue" "user_acct_run" {
  name                 = "user-run-request"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
}

resource "azurerm_storage_queue" "user_acct_run_poison" {
  name                 = "user-run-request-poison"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
}

resource "azurerm_storage_queue" "inactive_project_notification" {
  name                 = "project-inactivity-notification"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
}

resource "azurerm_storage_queue" "inactive_project_notification_poison" {
  name                 = "project-inactivity-notification-poison"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
}

resource "azurerm_storage_queue" "inactive_user_notification" {
  name                 = "user-inactivity-notification"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
}

resource "azurerm_storage_queue" "inactive_user_notification_poison" {
  name                 = "user-inactivity-notification-poison"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
}

resource "azurerm_storage_queue" "bug" {
  name                 = "bug-report"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
}

resource "azurerm_storage_queue" "bug_poison" {
  name                 = "bug-report-poison"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
}

resource "azurerm_storage_queue" "pong" {
  name                 = "pong-queue"
  storage_account_name = azurerm_storage_account.datahub_storageaccount.name
}
