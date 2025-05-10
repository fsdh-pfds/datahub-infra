resource "azurerm_key_vault_key" "datahub_cmk" {
  name         = var.key_vault_cmk_name
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
}

resource "azurerm_key_vault_key" "datahub_project_cmk" {
  name         = var.key_vault_cmk_name_proj
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
}

resource "azurerm_role_assignment" "kv_role_admin_group" {
  for_each = toset(["Key Vault Administrator", "Key Vault Crypto Officer", "Key Vault Crypto Officer", "Key Vault Secrets Officer"])

  scope                = var.key_vault_id
  principal_id         = var.aad_group_admin_oid
  role_definition_name = each.key
}

resource "tls_private_key" "dhadmin_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault_secret" "dhadmin_ssh_key" {
  name         = local.secret_name_dhadmin_ssh_key
  value        = tls_private_key.dhadmin_key.private_key_pem
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "dhadmin_ssh_public_key" {
  name         = local.secret_name_dhadmin_ssh_public_key
  value        = tls_private_key.dhadmin_key.public_key_openssh
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "aad_admin_group_oid" {
  name         = local.secret_name_admin_group_oid
  value        = var.aad_group_admin_oid
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "aad_dba_group_oid" {
  name         = local.secret_name_dba_group_oid
  value        = var.aad_group_dba_oid
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "azure_databricks_sp" {
  name         = local.secret_name_datahub_databricks_sp
  value        = var.azure_databricks_sp
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "pr_auto_approver_oid" {
  name         = local.secret_name_pr_auto_approver_oid
  value        = var.pr_auto_approver_oid
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "ado_service_user_oid" {
  name         = local.secret_name_ado_user_oid
  value        = "-"
  key_vault_id = var.key_vault_id

  lifecycle { ignore_changes = [value] }
}

resource "azurerm_key_vault_secret" "ado_service_user_pat" {
  name         = local.secret_name_ado_user_pat
  value        = "-"
  key_vault_id = var.key_vault_id

  lifecycle { ignore_changes = [value] }
}

resource "azurerm_ssh_public_key" "dhadmin_ssh" {
  name                = "dhadmin-ssh-${var.environment_name}"
  location            = var.az_region
  resource_group_name = var.az_resource_group
  public_key          = tls_private_key.dhadmin_key.public_key_openssh

  tags = merge(
    var.common_tags
  )
}

resource "azurerm_key_vault_secret" "teams_webhook_url" {
  name         = local.secret_name_teams_webhook_url
  value        = "-"
  key_vault_id = var.key_vault_id

  lifecycle { ignore_changes = [value] }
}



