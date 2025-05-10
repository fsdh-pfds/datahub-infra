resource "azurerm_automation_account" "datahub_automation_acct" {
  name                = local.automation_acct_name
  resource_group_name = var.az_resource_group
  location            = var.az_region
  sku_name            = "Basic"

  identity { type = "SystemAssigned" }
  tags = merge(var.common_tags)
}

resource "azurerm_automation_runbook" "datahub_app_scale_up" {
  name                    = local.scale_up_runbook_name
  resource_group_name     = var.az_resource_group
  location                = var.az_region
  automation_account_name = azurerm_automation_account.datahub_automation_acct.name
  log_verbose             = true
  log_progress            = true
  description             = "App service scale back up to normal size"
  runbook_type            = "PowerShell"

  draft {
    parameters {
      key      = "plan_sku"
      type     = "string"
      position = 0
    }
  }

  content = data.template_file.datahub_app_service_scale.rendered
  tags    = merge(var.common_tags)
}


resource "azurerm_automation_runbook" "datahub_app_scale_down" {
  name                    = local.scale_down_runbook_name
  resource_group_name     = var.az_resource_group
  location                = var.az_region
  automation_account_name = azurerm_automation_account.datahub_automation_acct.name
  log_verbose             = true
  log_progress            = true
  description             = "App service scale back up to normal size"
  runbook_type            = "PowerShell"

  draft {
    parameters {
      key      = "plan_sku"
      type     = "string"
      position = 0
    }
  }

  content = data.template_file.datahub_app_service_scale.rendered
  tags    = merge(var.common_tags)
}

resource "azurerm_automation_webhook" "datahub_scale_up_runbook_webhook" {
  name                    = "${local.scale_up_runbook_name}-webhook"
  resource_group_name     = var.az_resource_group
  automation_account_name = azurerm_automation_account.datahub_automation_acct.name
  expiry_time             = local.webhook_expiry_time
  enabled                 = true
  runbook_name            = azurerm_automation_runbook.datahub_app_scale_up.name

  parameters = {
    plan_sku = var.app_service_plan_sku_normal
  }
}

resource "azurerm_automation_webhook" "datahub_scale_down_runbook_webhook" {
  name                    = "${local.scale_down_runbook_name}-webhook"
  resource_group_name     = var.az_resource_group
  automation_account_name = azurerm_automation_account.datahub_automation_acct.name
  expiry_time             = local.webhook_expiry_time
  enabled                 = true
  runbook_name            = azurerm_automation_runbook.datahub_app_scale_down.name

  parameters = {
    plan_sku = var.app_service_plan_sku_down
  }
}

resource "azurerm_role_assignment" "automation_acct_assignment" {
  scope                = var.app_service_plan_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_automation_account.datahub_automation_acct.identity[0].principal_id
}

resource "azurerm_automation_schedule" "daily_scale_up" {
  name                    = "schedule-${local.scale_up_runbook_name}"
  resource_group_name     = var.az_resource_group
  automation_account_name = azurerm_automation_account.datahub_automation_acct.name
  frequency               = "Week"
  week_days               = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
  interval                = 1
  timezone                = "America/Toronto"
  start_time              = formatdate("YYYY-MM-DD'T'11:00:00Z", timeadd(timestamp(), "24h"))
  description             = "DataHub Schedule to scale back up to normal on week days"

  lifecycle {
    ignore_changes = [start_time]
  }
}

resource "azurerm_automation_schedule" "daily_scale_down" {
  name                    = "schedule-${local.scale_down_runbook_name}"
  resource_group_name     = var.az_resource_group
  automation_account_name = azurerm_automation_account.datahub_automation_acct.name
  frequency               = "Day"
  interval                = 1
  timezone                = "America/Toronto"
  start_time              = formatdate("YYYY-MM-DD'T'23:59:12Z", timeadd(timestamp(), "24h"))
  description             = "DataHub Schedule to scale down to smaller size at 8PM"

  lifecycle {
    ignore_changes = [start_time]
  }
}

resource "azurerm_automation_job_schedule" "app_service_scale_up_schedule" {
  count = var.app_service_plan_sku_down == "" ? 0 : 1

  resource_group_name     = var.az_resource_group
  automation_account_name = azurerm_automation_account.datahub_automation_acct.name
  schedule_name           = azurerm_automation_schedule.daily_scale_up.name
  runbook_name            = azurerm_automation_runbook.datahub_app_scale_up.name

  parameters = {
    plan_sku = var.app_service_plan_sku_normal
  }
}

resource "azurerm_automation_job_schedule" "app_service_scale_down_schedule" {
  count = var.app_service_plan_sku_down == "" ? 0 : 1

  resource_group_name     = var.az_resource_group
  automation_account_name = azurerm_automation_account.datahub_automation_acct.name
  schedule_name           = azurerm_automation_schedule.daily_scale_down.name
  runbook_name            = azurerm_automation_runbook.datahub_app_scale_down.name

  parameters = {
    plan_sku = var.app_service_plan_sku_down
  }
}
