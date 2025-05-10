resource "random_password" "datahub_psql_password" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "azurerm_key_vault_secret" "datahub_psql_secret" {
  name         = "datahub-psql-password"
  value        = random_password.datahub_psql_password.result
  key_vault_id = var.key_vault_id
}

resource "azurerm_role_assignment" "kv_role_psql" {
  for_each = toset(["Key Vault Crypto User", "Key Vault Certificate User"])

  scope                = var.key_vault_id
  principal_id         = azurerm_postgresql_server.datahub_psql.identity.0.principal_id
  role_definition_name = each.key
}
resource "azurerm_postgresql_server" "datahub_psql" {
  name                         = local.psql_server_name
  resource_group_name          = var.az_resource_group
  location                     = var.az_region
  administrator_login          = local.psql_admin_user
  administrator_login_password = random_password.datahub_psql_password.result

  sku_name   = "GP_Gen5_2"
  version    = "11"
  storage_mb = 51200

  ssl_enforcement_enabled = true

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  identity {
    type = "SystemAssigned"
  }

  tags = merge(
    var.common_tags
  )

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [sku_name, storage_mb, version]
  }
}

resource "azurerm_postgresql_server_key" "datahub_psql_key" {
  server_id        = azurerm_postgresql_server.datahub_psql.id
  key_vault_key_id = data.azurerm_key_vault_key.datahub_cmk.id

  depends_on = [azurerm_role_assignment.kv_role_psql]
}

resource "azurerm_postgresql_active_directory_administrator" "datahub_psql_ad_admin" {
  server_name         = azurerm_postgresql_server.datahub_psql.name
  resource_group_name = var.az_resource_group
  login               = var.aad_group_dba_name
  tenant_id           = var.az_tenant_id
  object_id           = var.aad_group_dba_oid
}

resource "azurerm_data_protection_backup_policy_postgresql" "datahub_psql_backup_policy" {
  name                = "${var.resource_prefix}-psql-backup-policy-${var.environment_name}"
  resource_group_name = var.az_resource_group
  vault_name          = data.azurerm_data_protection_backup_vault.datahub_backup_vault.name

  backup_repeating_time_intervals = ["R/2022-03-01T02:30:00+00:00/P1W"]

  default_retention_duration = "P4M"

  retention_rule {
    name     = "weekly"
    duration = "P6M"
    priority = 20
    criteria {
      absolute_criteria = "FirstOfWeek"
    }
  }

  retention_rule {
    name     = "thursday"
    duration = "P1W"
    priority = 25
    criteria {
      days_of_week           = ["Thursday"]
      scheduled_backup_times = ["2022-03-01T02:30:00Z"]
    }
  }

  retention_rule {
    name     = "monthly"
    duration = "P1D"
    priority = 15
    criteria {
      weeks_of_month         = ["First", "Last"]
      days_of_week           = ["Tuesday"]
      scheduled_backup_times = ["2022-03-01T02:30:00Z"]
    }
  }
}
