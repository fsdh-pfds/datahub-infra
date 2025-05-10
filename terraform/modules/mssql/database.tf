resource "azurerm_mssql_database" "datahub_sqldb_project" {
  name            = local.sql_database_project
  server_id       = azurerm_mssql_server.datahub_sql_server.id
  elastic_pool_id = azurerm_mssql_elasticpool.datahub_sql_pool.id
  enclave_type    = "VBS"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.datahub_mssql_uai.id]
  }
  transparent_data_encryption_enabled          = true
  transparent_data_encryption_key_vault_key_id = var.key_vault_cmk_id

  short_term_retention_policy {
    backup_interval_in_hours = 12
    retention_days           = 14
  }

  long_term_retention_policy {
    week_of_year      = 15
    weekly_retention  = "P12W"
    monthly_retention = "P36M"
    yearly_retention  = "P7Y"
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = merge(
    var.common_tags
  )
}

resource "azurerm_mssql_database" "datahub_sqldb_pip" {
  name            = local.sql_database_pip
  server_id       = azurerm_mssql_server.datahub_sql_server.id
  elastic_pool_id = azurerm_mssql_elasticpool.datahub_sql_pool.id
  enclave_type    = "VBS"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.datahub_mssql_uai.id]
  }
  transparent_data_encryption_enabled          = true
  transparent_data_encryption_key_vault_key_id = var.key_vault_cmk_id

  short_term_retention_policy {
    backup_interval_in_hours = 12
    retention_days           = 14
  }

  long_term_retention_policy {
    week_of_year      = 15
    weekly_retention  = "P12W"
    monthly_retention = "P36M"
    yearly_retention  = "P7Y"
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = merge(
    var.common_tags
  )

  depends_on = [azurerm_mssql_database.datahub_sqldb_project]
}

resource "azurerm_mssql_database" "datahub_sqldb_etl" {
  name            = local.sql_database_etl
  server_id       = azurerm_mssql_server.datahub_sql_server.id
  elastic_pool_id = azurerm_mssql_elasticpool.datahub_sql_pool.id
  enclave_type    = "VBS"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.datahub_mssql_uai.id]
  }
  transparent_data_encryption_enabled          = true
  transparent_data_encryption_key_vault_key_id = var.key_vault_cmk_id

  short_term_retention_policy {
    backup_interval_in_hours = 12
    retention_days           = 14
  }

  long_term_retention_policy {
    week_of_year      = 15
    weekly_retention  = "P12W"
    monthly_retention = "P36M"
    yearly_retention  = "P7Y"
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = merge(
    var.common_tags
  )

  depends_on = [azurerm_mssql_database.datahub_sqldb_pip]
}

resource "azurerm_mssql_database" "datahub_sqldb_webanalytics" {
  name            = local.sql_database_webanalytics
  server_id       = azurerm_mssql_server.datahub_sql_server.id
  elastic_pool_id = azurerm_mssql_elasticpool.datahub_sql_pool.id
  enclave_type    = "VBS"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.datahub_mssql_uai.id]
  }
  transparent_data_encryption_enabled          = true
  transparent_data_encryption_key_vault_key_id = var.key_vault_cmk_id

  short_term_retention_policy {
    backup_interval_in_hours = 12
    retention_days           = 14
  }

  long_term_retention_policy {
    week_of_year      = 15
    weekly_retention  = "P12W"
    monthly_retention = "P36M"
    yearly_retention  = "P7Y"
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = merge(
    var.common_tags
  )

  depends_on = [azurerm_mssql_database.datahub_sqldb_etl]
}

resource "azurerm_mssql_database" "datahub_sqldb_metadata" {
  name            = local.sql_database_metadata
  server_id       = azurerm_mssql_server.datahub_sql_server.id
  elastic_pool_id = azurerm_mssql_elasticpool.datahub_sql_pool.id
  enclave_type    = "VBS"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.datahub_mssql_uai.id]
  }
  transparent_data_encryption_enabled          = true
  transparent_data_encryption_key_vault_key_id = var.key_vault_cmk_id


  short_term_retention_policy {
    backup_interval_in_hours = 12
    retention_days           = 14
  }

  long_term_retention_policy {
    week_of_year      = 15
    weekly_retention  = "P12W"
    monthly_retention = "P36M"
    yearly_retention  = "P7Y"
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = merge(
    var.common_tags
  )

  depends_on = [azurerm_mssql_database.datahub_sqldb_webanalytics]
}

resource "azurerm_mssql_database" "datahub_sqldb_audit" {
  name            = local.sql_database_audit
  server_id       = azurerm_mssql_server.datahub_sql_server.id
  elastic_pool_id = azurerm_mssql_elasticpool.datahub_sql_pool.id
  enclave_type    = "VBS"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.datahub_mssql_uai.id]
  }
  transparent_data_encryption_enabled          = true
  transparent_data_encryption_key_vault_key_id = var.key_vault_cmk_id

  short_term_retention_policy {
    backup_interval_in_hours = 12
    retention_days           = 14
  }

  long_term_retention_policy {
    week_of_year      = 15
    weekly_retention  = "P12W"
    monthly_retention = "P36M"
    yearly_retention  = "P7Y"
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = merge(
    var.common_tags
  )

  depends_on = [azurerm_mssql_database.datahub_sqldb_metadata]
}

resource "azurerm_mssql_database" "datahub_sqldb_finance" {
  name            = local.sql_database_finance
  server_id       = azurerm_mssql_server.datahub_sql_server.id
  elastic_pool_id = azurerm_mssql_elasticpool.datahub_sql_pool.id
  enclave_type    = "VBS"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.datahub_mssql_uai.id]
  }
  transparent_data_encryption_enabled          = true
  transparent_data_encryption_key_vault_key_id = var.key_vault_cmk_id

  short_term_retention_policy {
    backup_interval_in_hours = 12
    retention_days           = 14
  }

  long_term_retention_policy {
    week_of_year      = 15
    weekly_retention  = "P12W"
    monthly_retention = "P36M"
    yearly_retention  = "P7Y"
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = merge(
    var.common_tags
  )

  depends_on = [azurerm_mssql_database.datahub_sqldb_audit]
}

resource "azurerm_mssql_database" "datahub_sqldb_training" {
  name            = local.sql_database_training
  server_id       = azurerm_mssql_server.datahub_sql_server.id
  elastic_pool_id = azurerm_mssql_elasticpool.datahub_sql_pool.id
  enclave_type    = "VBS"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.datahub_mssql_uai.id]
  }
  transparent_data_encryption_enabled          = true
  transparent_data_encryption_key_vault_key_id = var.key_vault_cmk_id

  short_term_retention_policy {
    backup_interval_in_hours = 12
    retention_days           = 14
  }

  long_term_retention_policy {
    week_of_year      = 15
    weekly_retention  = "P12W"
    monthly_retention = "P36M"
    yearly_retention  = "P7Y"
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = merge(
    var.common_tags
  )

  depends_on = [azurerm_mssql_database.datahub_sqldb_finance]
}

resource "azurerm_mssql_database" "datahub_sqldb_forms" {
  name            = local.sql_database_forms
  server_id       = azurerm_mssql_server.datahub_sql_server.id
  elastic_pool_id = azurerm_mssql_elasticpool.datahub_sql_pool.id
  enclave_type    = "VBS"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.datahub_mssql_uai.id]
  }
  transparent_data_encryption_enabled          = true
  transparent_data_encryption_key_vault_key_id = var.key_vault_cmk_id

  short_term_retention_policy {
    backup_interval_in_hours = 12
    retention_days           = 14
  }

  long_term_retention_policy {
    week_of_year      = 15
    weekly_retention  = "P12W"
    monthly_retention = "P36M"
    yearly_retention  = "P7Y"
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = merge(
    var.common_tags
  )

  depends_on = [azurerm_mssql_database.datahub_sqldb_finance]
}

