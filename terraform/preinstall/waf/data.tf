data "azurerm_client_config" "current" {}

locals {
  resource_group_name   = "${var.resource_prefix}-${var.environment_name}-hub-rg"
  resource_group_region = "canadacentral"

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
