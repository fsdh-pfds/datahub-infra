data "azurerm_client_config" "current" {}

data "azurerm_subscription" "az_subscription" {
  subscription_id = var.az_subscription_id
}

locals {
  automation_acct_name             = "${var.resource_prefix}-auto-${var.environment_name}"
  proj_common_automation_acct_name = lower(replace("${var.resource_prefix}-proj-common-${var.environment_name}-auto", "_", "-"))
  webhook_expiry_time              = "2025-12-31T00:00:00Z"
  scale_up_runbook_name            = "${var.resource_prefix}-auto-${var.environment_name}-app-scale-up"
  scale_down_runbook_name          = "${var.resource_prefix}-auto-${var.environment_name}-app-scale-down"
  secret_name_common_auto_acct     = "proj-common-auto-acct"
}

data "template_file" "datahub_app_service_scale" {
  template = file("${path.module}/app-service-plan-scale.ps1")
  vars = {
    subscription_id       = var.az_subscription_id
    resource_group_name   = var.az_resource_group
    app_service_plan_name = var.app_service_plan_name
    plan_sku              = var.app_service_plan_sku_normal
  }
}
