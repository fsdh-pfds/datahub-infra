resource "azurerm_private_endpoint" "datahub_kv_ep" {
  name                = "${var.resource_prefix}-${var.environment_name}-key-ep"
  location            = var.az_region
  resource_group_name = var.az_resource_group
  subnet_id           = azurerm_subnet.subnet_rz.id

  private_service_connection {
    name                           = local.kv_conn_name
    private_connection_resource_id = var.key_vault_id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  lifecycle {
    ignore_changes = [tags["ClientOrganization"], tags["CloudUsageProfile"], tags["DataSensitivity"], tags["Environment"], tags["ProjectEmail"], tags["ProjectName"], tags["TechnicalEmail"]]
  }
}

resource "azurerm_private_endpoint" "datahub_sql_ep" {
  name                = "${var.resource_prefix}-${var.environment_name}-mssql-ep"
  location            = var.az_region
  resource_group_name = var.az_resource_group
  subnet_id           = azurerm_subnet.subnet_rz.id

  private_service_connection {
    name                           = local.sql_conn_name
    private_connection_resource_id = var.mssql_id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  lifecycle {
    ignore_changes = [tags["ClientOrganization"], tags["CloudUsageProfile"], tags["DataSensitivity"], tags["Environment"], tags["ProjectEmail"], tags["ProjectName"], tags["TechnicalEmail"]]
  }
}

resource "azurerm_private_endpoint" "datahub_storage_ep" {
  name                = "${var.resource_prefix}-${var.environment_name}-storage-ep"
  location            = var.az_region
  resource_group_name = var.az_resource_group
  subnet_id           = azurerm_subnet.subnet_rz.id

  private_service_connection {
    name                           = local.storage_conn_name
    private_connection_resource_id = var.storage_id
    is_manual_connection           = false
    subresource_names              = ["Blob"]
  }

  lifecycle {
    ignore_changes = [tags["ClientOrganization"], tags["CloudUsageProfile"], tags["DataSensitivity"], tags["Environment"], tags["ProjectEmail"], tags["ProjectName"], tags["TechnicalEmail"]]
  }
}

resource "azurerm_private_endpoint" "datahub_datalake_ep" {
  name                = "${var.resource_prefix}-${var.environment_name}-datalake-ep"
  location            = var.az_region
  resource_group_name = var.az_resource_group
  subnet_id           = azurerm_subnet.subnet_rz.id

  private_service_connection {
    name                           = local.datalake_conn_name
    private_connection_resource_id = var.datalake_id
    is_manual_connection           = false
    subresource_names              = ["Blob"]
  }

  lifecycle {
    ignore_changes = [tags["ClientOrganization"], tags["CloudUsageProfile"], tags["DataSensitivity"], tags["Environment"], tags["ProjectEmail"], tags["ProjectName"], tags["TechnicalEmail"]]
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "datahub_app_vnet" {
  app_service_id = var.app_service_id
  subnet_id      = azurerm_subnet.subnet_app.id
}
