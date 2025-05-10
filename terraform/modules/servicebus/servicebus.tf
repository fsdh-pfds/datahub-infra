resource "azurerm_servicebus_namespace" "datahub_service_bus" {
    name                         = local.service_bus_name
    resource_group_name          = var.az_resource_group
    location                     = var.az_region
    sku                          = "Standard"
    
    tags = merge(
        var.common_tags
    )

    lifecycle {
        prevent_destroy = false
        ignore_changes  = [sku]
    }
}

#----------------------------------------#
#         Pong Queue
#----------------------------------------#
resource "azurerm_servicebus_queue" "datahub_pong_queue_queue" {
    namespace_id                = azurerm_servicebus_namespace.datahub_service_bus.id
    name                        = "pong-queue"
    enable_partitioning         = true
}

#----------------------------------------#
#         Serverless Queues
#----------------------------------------#
resource "azurerm_servicebus_queue" "datahub_bug_report_queue" {
    namespace_id                = azurerm_servicebus_namespace.datahub_service_bus.id
    name                        = "bug-report"
    enable_partitioning         = true
}
resource "azurerm_servicebus_queue" "datahub_email_notification_queue" {
    namespace_id                = azurerm_servicebus_namespace.datahub_service_bus.id
    name                        = "email-notification"
    enable_partitioning         = true
}
resource "azurerm_servicebus_queue" "datahub_infrastructure_health_check_queue" {
    namespace_id                = azurerm_servicebus_namespace.datahub_service_bus.id
    name                        = "infrastructure-health-check"
    enable_partitioning         = true
}
resource "azurerm_servicebus_queue" "datahub_project_capacity_update_queue" {
    namespace_id                = azurerm_servicebus_namespace.datahub_service_bus.id
    name                        = "project-capacity-update"
    enable_partitioning         = true
}
resource "azurerm_servicebus_queue" "datahub_project_inactivity_notification_queue" {
    namespace_id                = azurerm_servicebus_namespace.datahub_service_bus.id
    name                        = "project-inactivity-notification"
    enable_partitioning         = true
}
resource "azurerm_servicebus_queue" "datahub_project_usage_notification_queue" {
    namespace_id                = azurerm_servicebus_namespace.datahub_service_bus.id
    name                        = "project-usage-notification"
    enable_partitioning         = true
}
resource "azurerm_servicebus_queue" "datahub_project_usage_update_queue" {
    namespace_id                = azurerm_servicebus_namespace.datahub_service_bus.id
    name                        = "project-usage-update"
    enable_partitioning         = true
}
resource "azurerm_servicebus_queue" "datahub_user_inactivity_notification_queue" {
    namespace_id                = azurerm_servicebus_namespace.datahub_service_bus.id
    name                        = "user-inactivity-notification"
    enable_partitioning         = true
}
resource "azurerm_servicebus_queue" "datahub_terraform_output_handler_queue" {
    namespace_id                = azurerm_servicebus_namespace.datahub_service_bus.id
    name                        = "terraform-output-handler"
    enable_partitioning         = true
}
resource "azurerm_servicebus_queue" "datahub_workspace_app_serivce_configuration_queue" {
    namespace_id                = azurerm_servicebus_namespace.datahub_service_bus.id
    name                        = "workspace-app-service-configuration"
    enable_partitioning         = true
}
resource "azurerm_servicebus_queue" "datahub_infrastructure_health_check_results_queue" {
    namespace_id                = azurerm_servicebus_namespace.datahub_service_bus.id
    name                        = "infrastructure-health-check-results"
    enable_partitioning         = true
}
resource "azurerm_servicebus_queue" "datahub_project_inactive_queue" {
    namespace_id                = azurerm_servicebus_namespace.datahub_service_bus.id
    name                        = "project-inactive"
    enable_partitioning         = true
}

#----------------------------------------#
#         Resource Provision Queues
#----------------------------------------#
resource "azurerm_servicebus_queue" "datahub_resource_run_request_queue" {
    namespace_id                = azurerm_servicebus_namespace.datahub_service_bus.id
    name                        = "resource-run-request"
    enable_partitioning         = true
}

#----------------------------------------#
#         User Sync Queues
#----------------------------------------#
resource "azurerm_servicebus_queue" "datahub_user_run_request_queue" {
    namespace_id                = azurerm_servicebus_namespace.datahub_service_bus.id
    name                        = "user-run-request"
    enable_partitioning         = true
}

resource "azurerm_servicebus_queue" "datahub_databricks_sync_output_queue" {
    namespace_id                = azurerm_servicebus_namespace.datahub_service_bus.id
    name                        = "databricks-sync-output"
    enable_partitioning         = true
}

resource "azurerm_servicebus_queue" "datahub_storage_sync_output_queue" {
    namespace_id                = azurerm_servicebus_namespace.datahub_service_bus.id
    name                        = "storage-sync-output"
    enable_partitioning         = true
}

resource "azurerm_servicebus_queue" "datahub_keyvault_sync_output_queue" {
    namespace_id                = azurerm_servicebus_namespace.datahub_service_bus.id
    name                        = "keyvault-sync-output"
    enable_partitioning         = true
}
