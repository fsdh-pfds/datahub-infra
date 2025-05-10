data "azurerm_client_config" "current" {}

locals {
  resource_group_name   = "${var.resource_prefix}-${var.environment_name}-rg"
  resource_group_region = "canadacentral"
  key_vault_name        = "${var.resource_prefix}-key-${var.environment_name}"
  aad_group_admin       = "${var.resource_prefix}-group-admin-${var.environment_name}"
  aad_group_dba_name    = "${var.resource_prefix}-group-dba-${var.environment_name}"
  aad_group_users       = "${var.resource_prefix}-group-users-${var.environment_name}"
  app_service_name      = "${var.resource_prefix}-portal-app-${var.environment_name}"

  common_tags = {
    sector             = "Science Program"
    systemId           = var.resource_prefix
    Environment        = var.environment_name
    projectEmail       = var.support_email
    department         = "SSC"
    clientOrganization = "SSC-SPC"
    dataSensitivity    = var.environment_classification
    ProjectName        = "Canadian Federal Science DataHub"
    technicalEmail     = var.support_email
  }
}

resource "random_uuid" "sp_costing_id" {
}
