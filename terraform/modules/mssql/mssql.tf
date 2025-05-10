resource "azurerm_mssql_server" "datahub_sql_server" {
  name                         = local.sql_server_name
  resource_group_name          = var.az_resource_group
  location                     = var.az_region
  version                      = "12.0"
  administrator_login          = local.sql_username_admin
  administrator_login_password = random_password.datahub_sql_password.result
  minimum_tls_version          = "1.2"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.datahub_mssql_uai.id]
  }
  primary_user_assigned_identity_id = azurerm_user_assigned_identity.datahub_mssql_uai.id

  azuread_administrator {
    login_username              = var.aad_group_dba_name
    tenant_id                   = var.az_tenant_id
    object_id                   = var.aad_group_dba_oid
    azuread_authentication_only = false
  }

  tags = merge(
    var.common_tags
  )

  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      azuread_administrator
    ]
  }
}

resource "azurerm_mssql_elasticpool" "datahub_sql_pool" {
  name                = local.sql_pool_name
  server_name         = azurerm_mssql_server.datahub_sql_server.name
  resource_group_name = var.az_resource_group
  location            = var.az_region
  max_size_gb         = 4.8828125
  enclave_type        = "VBS"

  sku {
    name     = "BasicPool"
    tier     = "Basic"
    capacity = 50
  }

  per_database_settings {
    min_capacity = 0
    max_capacity = 5
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      tags,
      sku,
      per_database_settings,
    ]
  }
}

resource "random_password" "datahub_sql_password" {
  length           = 20
  min_lower        = 5
  min_upper        = 5
  min_numeric      = 5
  special          = true
  override_special = "_%@"
  lifecycle {
    ignore_changes = [min_lower, min_upper, min_numeric]
  }
}

resource "random_password" "datahub_readonly_password" {
  length           = 20
  min_lower        = 5
  min_upper        = 5
  min_numeric      = 5
  special          = true
  override_special = "_%@"
  lifecycle {
    ignore_changes = [min_lower, min_upper, min_numeric]
  }
}

resource "azurerm_mssql_server_extended_auditing_policy" "datahub_sql_audit" {
  server_id                               = azurerm_mssql_server.datahub_sql_server.id
  storage_endpoint                        = data.azurerm_storage_account.datahub_storageaccount.primary_blob_endpoint
  storage_account_access_key              = data.azurerm_storage_account.datahub_storageaccount.primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 3285
}

resource "time_sleep" "wait_300_seconds_dbuser" {
  depends_on = [azurerm_mssql_server.datahub_sql_server]

  create_duration = "300s"
}

resource "null_resource" "db_create_app_service_user_master" {
  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = <<-EOF
      $accessToken=(az account get-access-token --resource='https://database.windows.net' --query 'accessToken' -o tsv)
      Invoke-SqlCmd -ServerInstance ${azurerm_mssql_server.datahub_sql_server.fully_qualified_domain_name} -Database master -Query "CREATE USER [${var.app_service_name}] FROM EXTERNAL PROVIDER" -AccessToken "$accessToken"
    EOF
    on_failure  = fail
  }

  depends_on = [null_resource.config_db_firewall_temp_rule_add, time_sleep.wait_300_seconds_dbuser]
}

resource "null_resource" "db_create_app_service_slot_master" {
  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = <<-EOF
      $accessToken=(az account get-access-token --resource='https://database.windows.net' --query 'accessToken' -o tsv)
      Invoke-SqlCmd -ServerInstance ${azurerm_mssql_server.datahub_sql_server.fully_qualified_domain_name} -Database master -Query "CREATE USER [${var.app_service_slot_name}] FROM EXTERNAL PROVIDER" -AccessToken "$accessToken"
    EOF
    on_failure  = fail
  }

  depends_on = [null_resource.config_db_firewall_temp_rule_add, null_resource.db_create_app_service_user_master]
}

resource "null_resource" "db_create_function_app_user_master" {
  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = <<-EOF
      $accessToken=(az account get-access-token --resource='https://database.windows.net' --query 'accessToken' -o tsv)
      Invoke-SqlCmd -ServerInstance ${azurerm_mssql_server.datahub_sql_server.fully_qualified_domain_name} -Database master -Query "CREATE USER [${var.function_app_name}] FROM EXTERNAL PROVIDER" -AccessToken "$accessToken"
    EOF
    on_failure  = fail
  }

  depends_on = [null_resource.config_db_firewall_temp_rule_add, time_sleep.wait_300_seconds_dbuser]
}

resource "null_resource" "db_create_function_app_user" {
  for_each = toset(local.sql_db_names)

  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = <<-EOF
      $accessToken=(az account get-access-token --resource='https://database.windows.net' --query 'accessToken' -o tsv)
      Invoke-SqlCmd -ServerInstance ${azurerm_mssql_server.datahub_sql_server.fully_qualified_domain_name} -Database ${each.key} -Query "CREATE USER [${var.function_app_name}] FROM EXTERNAL PROVIDER" -AccessToken "$accessToken"
      Invoke-SqlCmd -ServerInstance ${azurerm_mssql_server.datahub_sql_server.fully_qualified_domain_name} -Database ${each.key} -Query "ALTER ROLE [db_datareader] ADD MEMBER [${var.function_app_name}]; ALTER ROLE [db_datawriter] ADD MEMBER [${var.function_app_name}]; ALTER ROLE [db_ddladmin] ADD MEMBER [${var.function_app_name}];" -AccessToken "$accessToken"
    EOF
    on_failure  = continue
  }

  depends_on = [null_resource.config_db_firewall_temp_rule_add, null_resource.db_create_function_app_user_master]
}

resource "null_resource" "db_create_func_app_res_prov_user_master" {
  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = <<-EOF
      $accessToken=(az account get-access-token --resource='https://database.windows.net' --query 'accessToken' -o tsv)
      Invoke-SqlCmd -ServerInstance ${azurerm_mssql_server.datahub_sql_server.fully_qualified_domain_name} -Database master -Query "CREATE USER [${var.function_app_name_res_prov}] FROM EXTERNAL PROVIDER" -AccessToken "$accessToken"
    EOF
    on_failure  = fail
  }

  depends_on = [null_resource.config_db_firewall_temp_rule_add, time_sleep.wait_300_seconds_dbuser]
}

resource "null_resource" "db_create_readonly_user_master" {
  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = <<-EOF
      $accessToken=(az account get-access-token --resource='https://database.windows.net' --query 'accessToken' -o tsv)
      Invoke-SqlCmd -ServerInstance ${azurerm_mssql_server.datahub_sql_server.fully_qualified_domain_name} -Database master -Query "CREATE USER [${local.sql_username_readonly}] WITH PASSWORD = '${random_password.datahub_readonly_password.result}'" -AccessToken "$accessToken"
    EOF
    on_failure  = fail
  }

  depends_on = [null_resource.config_db_firewall_temp_rule_add, time_sleep.wait_300_seconds_dbuser]
}

resource "null_resource" "db_create_func_app_res_prov_user" {
  for_each = toset(local.sql_db_names)

  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = <<-EOF
      $accessToken=(az account get-access-token --resource='https://database.windows.net' --query 'accessToken' -o tsv)
      Invoke-SqlCmd -ServerInstance ${azurerm_mssql_server.datahub_sql_server.fully_qualified_domain_name} -Database ${each.key} -Query "CREATE USER [${var.function_app_name_res_prov}] FROM EXTERNAL PROVIDER" -AccessToken "$accessToken"
      Invoke-SqlCmd -ServerInstance ${azurerm_mssql_server.datahub_sql_server.fully_qualified_domain_name} -Database ${each.key} -Query "ALTER ROLE [db_datareader] ADD MEMBER [${var.function_app_name_res_prov}]; ALTER ROLE [db_datawriter] ADD MEMBER [${var.function_app_name_res_prov}]; ALTER ROLE [db_ddladmin] ADD MEMBER [${var.function_app_name_res_prov}];" -AccessToken "$accessToken"
    EOF
    on_failure  = continue
  }

  depends_on = [null_resource.config_db_firewall_temp_rule_add, null_resource.db_create_func_app_res_prov_user_master]
}

resource "null_resource" "db_create_app_service_user" {
  for_each = toset(local.sql_db_names)

  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = <<-EOF
      $accessToken=(az account get-access-token --resource='https://database.windows.net' --query 'accessToken' -o tsv)
      Invoke-SqlCmd -ServerInstance ${azurerm_mssql_server.datahub_sql_server.fully_qualified_domain_name} -Database ${each.key} -Query "CREATE USER [${var.app_service_name}] FROM EXTERNAL PROVIDER" -AccessToken "$accessToken"
      Invoke-SqlCmd -ServerInstance ${azurerm_mssql_server.datahub_sql_server.fully_qualified_domain_name} -Database ${each.key} -Query "ALTER ROLE [db_datareader] ADD MEMBER [${var.app_service_name}]; ALTER ROLE [db_datawriter] ADD MEMBER [${var.app_service_name}]; ALTER ROLE [db_ddladmin] ADD MEMBER [${var.app_service_name}];" -AccessToken "$accessToken"
    EOF
    on_failure  = fail
  }

  depends_on = [null_resource.config_db_firewall_temp_rule_add, null_resource.db_create_app_service_user_master]
}

resource "null_resource" "db_create_readonly_user" {
  for_each = toset(local.sql_db_names)

  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = <<-EOF
      $accessToken=(az account get-access-token --resource='https://database.windows.net' --query 'accessToken' -o tsv)
      Invoke-SqlCmd -ServerInstance ${azurerm_mssql_server.datahub_sql_server.fully_qualified_domain_name} -Database ${each.key} -Query "CREATE USER [${local.sql_username_readonly}] WITH PASSWORD = '${random_password.datahub_readonly_password.result}'" -AccessToken "$accessToken"
      Invoke-SqlCmd -ServerInstance ${azurerm_mssql_server.datahub_sql_server.fully_qualified_domain_name} -Database ${each.key} -Query "ALTER ROLE [db_datareader] ADD MEMBER [${local.sql_username_readonly}];" -AccessToken "$accessToken"
    EOF
    on_failure  = fail
  }

  depends_on = [null_resource.config_db_firewall_temp_rule_add, null_resource.db_create_readonly_user_master]
}

resource "null_resource" "db_create_app_service_user_slot" {
  for_each = toset(local.sql_db_names)

  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = <<-EOF
      if (${var.app_create_slot}){
        $accessToken=(az account get-access-token --resource='https://database.windows.net' --query 'accessToken' -o tsv)
        Invoke-SqlCmd -ServerInstance ${azurerm_mssql_server.datahub_sql_server.fully_qualified_domain_name} -Database ${each.key} -Query "CREATE USER [${var.app_service_slot_name}] FROM EXTERNAL PROVIDER" -AccessToken "$accessToken"
        Invoke-SqlCmd -ServerInstance ${azurerm_mssql_server.datahub_sql_server.fully_qualified_domain_name} -Database ${each.key} -Query "ALTER ROLE [db_datareader] ADD MEMBER [${var.app_service_slot_name}]; ALTER ROLE [db_datawriter] ADD MEMBER [${var.app_service_slot_name}]; ALTER ROLE [db_ddladmin] ADD MEMBER [${var.app_service_slot_name}];" -AccessToken "$accessToken"
      }
    EOF
    on_failure  = fail
  }

  depends_on = [null_resource.config_db_firewall_temp_rule_add, null_resource.db_create_app_service_slot_master]
}

resource "null_resource" "config_db_firewall_temp_rule_add" {
  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = <<-EOF
      az sql server firewall-rule create -g ${var.az_resource_group} -s ${azurerm_mssql_server.datahub_sql_server.name} -n "${local.firewall_name_myip}" --start-ip-address "${trimspace(data.http.myip.response_body)}" --end-ip-address "${trimspace(data.http.myip.response_body)}"
    EOF
    on_failure  = fail
  }

  triggers = { always_run = "${timestamp()}" }
}

resource "null_resource" "config_db_firewall_temp_rule_delete" {
  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = <<-EOF
      az sql server firewall-rule delete -g ${var.az_resource_group} -s ${azurerm_mssql_server.datahub_sql_server.name} -n "${local.firewall_name_myip}"
    EOF
    on_failure  = fail
  }

  triggers   = { always_run = "${timestamp()}" }
  depends_on = [null_resource.db_create_app_service_user_slot, null_resource.db_create_app_service_user, null_resource.db_create_function_app_user, null_resource.db_create_readonly_user]
}


