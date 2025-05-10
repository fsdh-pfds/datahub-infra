data "azurerm_client_config" "current" {}
data "azurerm_resource_group" "datahub_rg" { name = var.az_resource_group }

data "azurerm_key_vault" "datahub_key_vault" {
  name                = var.key_vault_name
  resource_group_name = data.azurerm_resource_group.datahub_rg.name
}

data "azurerm_key_vault_secret" "secret_client_id" {
  name         = local.secret_name_client_id
  key_vault_id = data.azurerm_key_vault.datahub_key_vault.id
}

data "azurerm_key_vault_secret" "secret_client_oid" {
  name         = local.secret_name_client_oid
  key_vault_id = data.azurerm_key_vault.datahub_key_vault.id
}

data "azurerm_key_vault_secret" "secret_client_secret" {
  name         = local.secret_name_client_secret
  key_vault_id = data.azurerm_key_vault.datahub_key_vault.id
}

data "azurerm_key_vault_secret" "secret_smtp_user" {
  name         = local.secret_name_smtp_user
  key_vault_id = data.azurerm_key_vault.datahub_key_vault.id
}

data "azurerm_key_vault_secret" "secret_smtp_password" {
  name         = local.secret_name_smtp_password
  key_vault_id = data.azurerm_key_vault.datahub_key_vault.id
}

data "azurerm_key_vault_secret" "secret_deepl_authkey" {
  name         = local.secret_name_deepl_authkey
  key_vault_id = data.azurerm_key_vault.datahub_key_vault.id
}

locals {
  secret_name_admin_group_oid        = "aad-admin-group-oid"
  secret_name_dba_group_oid          = "aad-dba-group-oid"
  secret_name_client_oid             = "datahubportal-client-oid"
  secret_name_client_id              = "datahubportal-client-id"
  secret_name_client_secret          = "datahubportal-client-secret"
  secret_name_smtp_user              = "datahub-smtp-username"
  secret_name_smtp_password          = "datahub-smtp-password"
  secret_name_deepl_authkey          = "deepl-authkey"
  secret_name_datahub_databricks_sp  = "datahub-databricks-sp"
  secret_name_dhadmin_ssh_key        = "dhadmin-ssh-key"
  secret_name_dhadmin_ssh_public_key = "dhadmin-ssh-public-key"
  secret_name_pr_auto_approver_oid   = "datahub-infrastructure-repo-auto-approver-oid"
  secret_name_ado_user_oid           = "ado-service-user-oid"
  secret_name_ado_user_pat           = "ado-service-user-pat"
  secret_name_teams_webhook_url      = "teams-webhook-url"
}
