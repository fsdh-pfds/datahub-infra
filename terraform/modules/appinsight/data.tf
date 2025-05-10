data "azurerm_client_config" "current" {}

locals {
  log_analytics_workspace_name   = "${var.resource_prefix}-portal-log-${var.environment_name}"
  app_insight_name_app           = "${var.resource_prefix}-app-insights-portal-${var.environment_name}"
  app_insight_name_func          = "${var.resource_prefix}-app-insights-func-${var.environment_name}"
  app_insight_name_func_res_prov = "${var.resource_prefix}-app-insights-func-res_prov-${var.environment_name}"
  app_insight_name_func_py       = "${var.resource_prefix}-app-insights-func-py-${var.environment_name}"
}
