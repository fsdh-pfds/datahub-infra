data "azurerm_client_config" "current" {}

locals {
  common_tags = {
    sector             = "Science Program"
    systemId           = var.resource_prefix
    Environment        = var.environment_name
    projectEmail       = var.alert_email_address
    department         = "SSC"
    clientOrganization = "SSC-SPC"
    dataSensitivity    = var.environment_classification
    ProjectName        = "Canadian Federal Science DataHub"
    technicalEmail     = var.alert_email_address
    CloudUsageProfile  = "1"
  }
}

data "external" "git_version_output" {
  program = ["powershell", "-File", "${path.module}/git-version.ps1"]
}

data "external" "git_branch_output" {
  program = ["powershell", "-File", "${path.module}/git-branch.ps1"]
}

module "appservice" {
  source                = "../modules/appservice"
  depends_on            = [module.appinsight, module.storage]
  az_tenant_id          = var.az_tenant_id
  az_subscription_id    = var.az_subscription_id
  ws_subscription_id    = var.ws_subscription_id
  az_resource_group     = var.az_resource_group
  aad_domain            = var.aad_domain
  app_service_sku       = var.app_service_sku
  app_service_workers   = var.app_service_workers
  app_create_slot       = var.app_create_slot
  key_vault_name        = var.key_vault_name
  key_vault_id          = var.key_vault_id
  key_vault_uri         = data.azurerm_key_vault.datahub_key_vault.vault_uri
  environment_name      = var.environment_name
  common_tags           = local.common_tags
  resource_prefix       = var.resource_prefix
  powerbi_url_spi       = var.powerbi_url_spi
  app_service_always_on = var.app_service_always_on
  project_module_branch = var.project_module_branch

  app_insights_key               = module.appinsight.app_insights_key
  app_insights_str               = module.appinsight.app_insights_str
  app_insights_str_func          = module.appinsight.app_insights_str_func
  app_insights_str_func_res_prov = module.appinsight.app_insights_str_func_res_prov
  app_insights_str_func_py       = module.appinsight.app_insights_str_func_py

  sql_server_dns            = module.mssql.mssql_dns
  sql_database_project      = module.mssql.mssql_db_name_project
  sql_database_pip          = module.mssql.mssql_db_name_pip
  sql_database_etl          = module.mssql.mssql_db_name_etl
  sql_database_webanalytics = module.mssql.mssql_db_name_webanalytics
  sql_database_metadata     = module.mssql.mssql_db_name_metadata
  sql_database_audit        = module.mssql.mssql_db_name_audit
  sql_database_finance      = module.mssql.mssql_db_name_finance
  sql_database_training     = module.mssql.mssql_db_name_training
  sql_database_forms        = module.mssql.mssql_db_name_forms

  service_bus_connection_string_secret_name = module.service_bus.connection_string_secret_name

  datalake_storage_account_name = module.datalake.datalake_storage_account_name
  storage_account_name          = module.storage.blob_storage_account_name
  storage_account_id            = module.storage.blobstorage_id
  smtp_sender_name              = var.smtp_sender_name
  smtp_sender_address           = var.smtp_sender_address
  team_contact_email            = var.contact_email

  search_service_name  = "-"
  powerbi_pdf_base_url = var.powerbi_pdf_base_url
  log_workspace_id     = var.log_workspace_id
  datahub_filesystem   = module.datalake.datahub_filesystem_name
  default_user_group   = var.default_user_group
  azure_dns_record     = var.azure_dns_record
  azure_dns_zone_name  = var.azure_dns_zone_name
  azure_dns_zone_rg    = var.azure_dns_zone_rg
  ssl_cert_kv_id       = var.ssl_cert_kv_id
  ssl_cert_name        = var.ssl_cert_name

  global_var = local.datahub

  desktop_uploader_display_tab     = var.desktop_uploader_display_tab
  reverse_proxy_enabled            = var.reverse_proxy_enabled
  reverse_proxy_path               = var.reverse_proxy_path
  ckan_enabled                     = var.ckan_enabled
  ckan_baseurl                     = var.ckan_baseurl
  ckan_testmode                    = var.ckan_testmode
  project_automation_acct_uai_name = module.automation.project_common_auto_acct_uai_name
  project_automation_acct_uai_rg   = module.automation.project_common_auto_acct_uai_rg
  project_automation_acct_uai_sub  = module.automation.project_common_auto_acct_uai_sub
  ado_org_name                     = var.ado_org_name
  ado_project_name                 = var.ado_project_name
  bug_report_teams_webhook_url     = var.bug_report_teams_webhook_url
}

module "appinsight" {
  source              = "../modules/appinsight"
  depends_on          = [module.preinstall]
  az_resource_group   = var.az_resource_group
  environment_name    = var.environment_name
  resource_prefix     = var.resource_prefix
  common_tags         = local.common_tags
  log_workspace_id    = var.log_workspace_id
  alert_email_address = var.alert_email_address
  send_alert_email    = var.send_alert_email
}

module "storage" {
  source             = "../modules/storage"
  depends_on         = [module.appinsight, module.security]
  az_tenant_id       = var.az_tenant_id
  az_resource_group  = var.az_resource_group
  environment_name   = var.environment_name
  resource_prefix    = var.resource_prefix
  common_tags        = local.common_tags
  log_workspace_id   = var.log_workspace_id
  key_vault_name     = var.key_vault_name
  key_vault_id       = var.key_vault_id
  key_vault_cmk_name = module.security.datahub_cmk_name
}

module "datalake" {
  source               = "../modules/datalake"
  depends_on           = [module.appinsight, module.security, module.storage]
  az_tenant_id         = var.az_tenant_id
  az_resource_group    = var.az_resource_group
  environment_name     = var.environment_name
  resource_prefix      = var.resource_prefix
  aad_group_admin_oid  = var.aad_group_admin_oid
  common_tags          = local.common_tags
  log_workspace_id     = var.log_workspace_id
  key_vault_name       = var.key_vault_name
  key_vault_id         = var.key_vault_id
  key_vault_cmk_name   = module.security.datahub_cmk_name
  storage_account_name = module.storage.blob_storage_account_name
}

module "security" {
  source               = "../modules/security"
  depends_on           = [module.appinsight]
  az_tenant_id         = var.az_tenant_id
  az_resource_group    = var.az_resource_group
  environment_name     = var.environment_name
  common_tags          = local.common_tags
  resource_prefix      = var.resource_prefix
  aad_group_admin_oid  = var.aad_group_admin_oid
  aad_group_dba_oid    = var.aad_group_dba_oid
  key_vault_name       = var.key_vault_name
  key_vault_id         = var.key_vault_id
  azure_databricks_sp  = var.azure_databricks_sp
  pr_auto_approver_oid = var.pr_auto_approver_oid
}

module "backup" {
  source               = "../modules/backup"
  depends_on           = [module.appinsight, module.storage]
  az_tenant_id         = var.az_tenant_id
  az_resource_group    = var.az_resource_group
  environment_name     = var.environment_name
  common_tags          = local.common_tags
  resource_prefix      = var.resource_prefix
  storage_account_name = module.storage.blob_storage_account_name
}

module "mssql" {
  source                     = "../modules/mssql"
  depends_on                 = [module.appinsight, module.storage, module.appservice.datahub_portal_app_service_slot, module.appservice.datahub_portal_app_service, module.appservice.datahub_portal_app_service]
  az_tenant_id               = var.az_tenant_id
  az_resource_group          = var.az_resource_group
  environment_name           = var.environment_name
  common_tags                = local.common_tags
  resource_prefix            = var.resource_prefix
  app_service_name           = module.appservice.app_service_name
  app_create_slot            = var.app_create_slot
  app_service_slot_name      = module.appservice.app_service_slot_name
  function_app_name          = module.appservice.function_app_name
  function_app_name_res_prov = module.appservice.function_app_res_prov_name
  key_vault_name             = var.key_vault_name
  key_vault_id               = var.key_vault_id
  key_vault_cmk_name         = module.security.datahub_cmk_name
  key_vault_cmk_id           = module.security.datahub_cmk_id_with_version
  aad_group_dba_oid          = var.aad_group_dba_oid
  aad_group_dba_name         = var.aad_group_dba_name
  storage_account_name       = module.storage.blob_storage_account_name
}

module "network" {
  source                     = "../modules/network"
  depends_on                 = [module.security, module.storage, module.backup, module.appinsight]
  az_tenant_id               = var.az_tenant_id
  az_resource_group          = var.az_resource_group
  environment_name           = var.environment_name
  common_tags                = local.common_tags
  resource_prefix            = var.resource_prefix
  key_vault_name             = var.key_vault_name
  key_vault_id               = var.key_vault_id
  key_vault_cmk_name         = module.security.datahub_cmk_name
  storage_account_name       = module.storage.blob_storage_account_name
  backup_vault_name          = module.backup.backup_vault_name
  app_service_id             = module.appservice.app_service_id
  app_service_name           = module.appservice.app_service_name
  function_app_name          = module.appservice.function_app_name
  function_app_name_res_prov = module.appservice.function_app_res_prov_name
  function_app_name_py       = module.appservice.function_app_py_name
  azure_dns_record           = var.azure_dns_record
  azure_dns_zone_name        = var.azure_dns_zone_name
  azure_dns_zone_rg          = var.azure_dns_zone_rg

  mssql_name  = module.mssql.mssql_name
  mssql_id    = module.mssql.mssql_id
  storage_id  = module.storage.blobstorage_id
  datalake_id = module.datalake.datalake_storage_id
}


module "automation" {
  source                      = "../modules/automation"
  az_tenant_id                = var.az_tenant_id
  az_subscription_id          = var.az_subscription_id
  az_resource_group           = var.az_resource_group
  environment_name            = var.environment_name
  common_tags                 = local.common_tags
  resource_prefix             = var.resource_prefix
  key_vault_id                = var.key_vault_id
  app_service_plan_name       = module.appservice.datahub_portal_app_service_plan_name
  app_service_plan_id         = module.appservice.datahub_portal_app_service_plan
  app_service_plan_sku_normal = module.appservice.datahub_portal_app_service_plan_sku
  app_service_plan_sku_down   = var.app_service_sku_down
}

module "preinstall" {
  source            = "../modules/preinstall"
  az_tenant_id      = var.az_tenant_id
  az_resource_group = var.az_resource_group
  environment_name  = var.environment_name
  common_tags       = local.common_tags
  resource_prefix   = var.resource_prefix
  key_vault_name    = var.key_vault_name
  key_vault_id      = var.key_vault_id
  git_version_url   = data.external.git_version_output.result["git_url"]
  git_branch_name   = data.external.git_branch_output.result["git_branch"]
}

module "service_bus" {
  source            = "../modules/servicebus"
  az_tenant_id      = var.az_tenant_id
  az_resource_group = var.az_resource_group
  environment_name  = var.environment_name
  common_tags       = local.common_tags
  resource_prefix   = var.resource_prefix
  key_vault_name    = var.key_vault_name
  key_vault_id      = var.key_vault_id
}
