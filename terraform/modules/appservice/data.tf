data "azurerm_client_config" "current" {}

data "azurerm_storage_account" "datahub_storageaccount" {
  name                = var.storage_account_name
  resource_group_name = var.az_resource_group
}

data "azurerm_key_vault_secret" "secret_client_oid" {
  name         = local.secret_name_client_oid
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "secret_client_id" {
  name         = local.secret_name_client_id
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "secret_storage_account" {
  name         = local.secret_name_datahub_storage_queue_conn_str
  key_vault_id = var.key_vault_id
}

data "azurerm_storage_account_blob_container_sas" "datahub_app_log_sas" {
  connection_string = data.azurerm_storage_account.datahub_storageaccount.primary_connection_string
  container_name    = var.log_container
  https_only        = true

  start  = local.sas_start_now
  expiry = local.sas_expiry_1y

  permissions {
    read   = true
    add    = true
    create = true
    write  = true
    delete = true
    list   = true
  }
}

data "azurerm_storage_account_blob_container_sas" "datahub_backup_sas" {
  connection_string = data.azurerm_storage_account.datahub_storageaccount.primary_connection_string
  container_name    = var.global_var.config_name.container_backup
  https_only        = true

  start  = local.sas_start_now
  expiry = local.sas_expiry_1y

  permissions {
    read   = true
    add    = true
    create = true
    write  = true
    delete = true
    list   = true
  }
}

locals {
  app_service_name        = "${var.resource_prefix}-portal-app-${var.environment_name}"
  func_app_name_res_prov  = "${var.resource_prefix}-func-res-prov-${var.environment_name}"
  func_app_name_dotnet    = "${var.resource_prefix}-func-dotnet-${var.environment_name}"
  func_app_name_ps        = "${var.resource_prefix}-func-ps-${var.environment_name}"
  func_app_name_py        = "${var.resource_prefix}-func-py-${var.environment_name}"
  func_app_name_ps_secure = "${var.resource_prefix}-func-ps-secure-${var.environment_name}"
  signalr_name            = "${var.resource_prefix}-signalr-${var.environment_name}"
  default_project_budget  = "100"
  gc_cert                 = "gc.cer"
  kv_user_roles           = toset(["Key Vault Crypto User", "Key Vault Certificate User", "Key Vault Secrets User"])
  sas_start_now           = formatdate("YYYY-MM-DD", timestamp())
  sas_expiry_1y           = "${formatdate("YYYY", timestamp()) + 1}-${formatdate("MM-DD", timestamp())}"

  secret_name_admin_group_oid                    = "aad-admin-group-oid"
  secret_name_dba_group_oid                      = "aad-dba-group-oid"
  secret_name_client_id                          = "datahubportal-client-id"
  secret_name_client_oid                         = "datahubportal-client-oid"
  secret_name_client_secret                      = "datahubportal-client-secret"
  secret_name_devops_client_id                   = "devops-client-id"
  secret_name_devops_client_secret               = "devops-client-secret"
  secret_name_devops_service_user_oid            = "ado-service-user-oid"
  secret_name_devops_service_user_pat            = "ado-service-user-pat"
  secret_name_smtp_username                      = "datahub-smtp-username"
  secret_name_smtp_password                      = "datahub-smtp-password"
  secret_name_deepl_key                          = "deepl-authkey"
  secret_name_graph_user_create_url              = "datahub-create-graph-user-url"
  secret_name_graph_user_status_url              = "datahub-status-graph-user-url"
  secret_name_datahub_storage_queue_conn_str     = "datahub-storage-queue-conn-str"
  secret_name_datahub_media_conn_str             = "datahub-media-storage-connection-string"
  secret_name_infrastructure_repo_url            = "datahub-infrastructure-repo-url"
  secret_name_infrastructure_repo_username       = "datahub-infrastructure-repo-username"
  secret_name_infrastructure_repo_password       = "datahub-infrastructure-repo-password"
  secret_name_infrastructure_repo_pr_url         = "datahub-infrastructure-repo-pr-url"
  secret_name_infrastructure_repo_pr_browser_url = "datahub-infrastructure-repo-pr-browser-url"
  secret_name_databricks_sp                      = "datahub-databricks-sp"
  secret_name_pr_auto_approver_oid               = "datahub-infrastructure-repo-auto-approver-oid"
  secret_name_teams_webhook_url                  = "teams-webhook-url"
}
