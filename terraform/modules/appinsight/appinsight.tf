resource "azurerm_application_insights" "datahub_appinsight_app" {
  name                = local.app_insight_name_app
  resource_group_name = var.az_resource_group
  location            = var.az_region
  workspace_id        = var.log_workspace_id
  application_type    = "web"
  retention_in_days   = var.log_retention_days

  tags = merge(
    var.common_tags
  )
}

resource "azurerm_application_insights" "datahub_appinsight_function" {
  name                = local.app_insight_name_func
  resource_group_name = var.az_resource_group
  location            = var.az_region
  workspace_id        = var.log_workspace_id
  application_type    = "web"

  tags = merge(
    var.common_tags
  )
}

resource "azurerm_application_insights" "datahub_appinsight_function_res_prov" {
  name                = local.app_insight_name_func_res_prov
  resource_group_name = var.az_resource_group
  location            = var.az_region
  workspace_id        = var.log_workspace_id
  application_type    = "web"

  tags = merge(
    var.common_tags
  )
}

resource "azurerm_application_insights" "datahub_appinsight_function_py" {
  name                = local.app_insight_name_func_py
  resource_group_name = var.az_resource_group
  location            = var.az_region
  workspace_id        = var.log_workspace_id
  application_type    = "web"

  tags = merge(var.common_tags)
}

resource "azurerm_application_insights_api_key" "app_service_key" {
  name                    = "${var.resource_prefix}-app-insights-portal-key"
  application_insights_id = azurerm_application_insights.datahub_appinsight_app.id
  read_permissions        = ["agentconfig", "aggregate", "api", "draft", "extendqueries", "search"]
  write_permissions       = ["annotations"]
}

resource "azurerm_application_insights_api_key" "function_app_key" {
  name                    = "${var.resource_prefix}-app-insights-func-key"
  application_insights_id = azurerm_application_insights.datahub_appinsight_function.id
  read_permissions        = ["agentconfig", "aggregate", "api", "draft", "extendqueries", "search"]
  write_permissions       = ["annotations"]
}

resource "azurerm_application_insights_api_key" "func_res_prov_key" {
  name                    = "${var.resource_prefix}-app-insights-portal-key"
  application_insights_id = azurerm_application_insights.datahub_appinsight_function_res_prov.id
  read_permissions        = ["agentconfig", "aggregate", "api", "draft", "extendqueries", "search"]
  write_permissions       = ["annotations"]
}

resource "azurerm_application_insights_api_key" "function_app_py_key" {
  name                    = "${var.resource_prefix}-app-insights-func-key"
  application_insights_id = azurerm_application_insights.datahub_appinsight_function_py.id
  read_permissions        = ["agentconfig", "aggregate", "api", "draft", "extendqueries", "search"]
  write_permissions       = ["annotations"]
}

resource "azurerm_monitor_action_group" "datahub_app_alert_group" {
  name                = "${var.resource_prefix}-portal-email-actiongroup-${var.environment_name}"
  resource_group_name = var.az_resource_group
  short_name          = "p0action"

  email_receiver {
    name          = "datahub_notification_email"
    email_address = var.alert_email_address
  }

  tags = merge(
    var.common_tags
  )
}

resource "azurerm_monitor_metric_alert" "datahub_app_exception_alert" {
  count = var.send_alert_email ? 1 : 0

  name                = "${var.resource_prefix}-app-alert-${var.environment_name}"
  resource_group_name = var.az_resource_group
  severity            = "3"
  scopes              = [azurerm_application_insights.datahub_appinsight_app.id]
  window_size         = "PT6H"
  frequency           = "PT1H"
  description         = "Exception alert in the last 6 hours in ${azurerm_application_insights.datahub_appinsight_app.name}"

  criteria {
    metric_namespace = "microsoft.insights/components"
    metric_name      = "exceptions/count"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = var.alerts_count_trigger_email
  }

  action {
    action_group_id = azurerm_monitor_action_group.datahub_app_alert_group.id
  }

  tags = merge(
    var.common_tags
  )
}
