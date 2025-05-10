# Azure Key Vault
resource "azurerm_key_vault" "datahub_key_vault" {
  name                            = local.key_vault_name
  location                        = azurerm_resource_group.datahub_rg.location
  resource_group_name             = azurerm_resource_group.datahub_rg.name
  enabled_for_disk_encryption     = true
  tenant_id                       = var.az_tenant_id
  soft_delete_retention_days      = 90
  purge_protection_enabled        = true
  enabled_for_template_deployment = true

  sku_name = "standard"

  tags = merge(
    local.common_tags
  )

  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_role_assignment" "kv_role_creator" {
  for_each = toset(["Key Vault Crypto User", "Key Vault Certificate User", "Key Vault Secrets User", "Key Vault Administrator", "Contributor", "Owner"])

  scope                = azurerm_key_vault.datahub_key_vault.id
  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = each.key
}

resource "azurerm_key_vault_secret" "portal_client_id" {
  name         = "datahubportal-client-id"
  value        = azuread_application.datahub_app_registration_core.application_id # aka Client ID
  key_vault_id = azurerm_key_vault.datahub_key_vault.id

  lifecycle {
    ignore_changes = [value]
  }

  depends_on = [azurerm_role_assignment.kv_role_creator]
}

resource "azurerm_key_vault_secret" "portal_client_id" {
  name         = "datahubportal-client-oid"
  value        = azuread_application.datahub_app_registration_core.object_id # aka Client ID
  key_vault_id = azurerm_key_vault.datahub_key_vault.id

  lifecycle {
    ignore_changes = [value]
  }

  depends_on = [azurerm_role_assignment.kv_role_creator]
}

resource "azurerm_key_vault_secret" "portal_client_secret" {
  name         = "datahubportal-client-secret"
  value        = azuread_application_password.datahub_app_secret_core.value
  key_vault_id = azurerm_key_vault.datahub_key_vault.id

  lifecycle {
    ignore_changes = [value]
  }

  depends_on = [azurerm_role_assignment.kv_role_creator]
}

resource "azurerm_key_vault_secret" "smtp_username" {
  name         = "datahub-smtp-username"
  value        = "-"
  key_vault_id = azurerm_key_vault.datahub_key_vault.id

  lifecycle {
    ignore_changes = [value]
  }

  depends_on = [azurerm_role_assignment.kv_role_creator]
}

resource "azurerm_key_vault_secret" "smtp_password" {
  name         = "datahub-smtp-password"
  value        = "-"
  key_vault_id = azurerm_key_vault.datahub_key_vault.id

  lifecycle {
    ignore_changes = [value]
  }

  depends_on = [azurerm_role_assignment.kv_role_creator]
}

resource "azurerm_key_vault_secret" "devops_client_id" {
  name         = "devops-client-id"
  value        = azuread_application.datahub_app_registration_devops.application_id
  key_vault_id = azurerm_key_vault.datahub_key_vault.id

  lifecycle {
    ignore_changes = [value]
  }

  depends_on = [azurerm_role_assignment.kv_role_creator]
}

resource "azurerm_key_vault_secret" "devops_client_secret" {
  name         = "devops-client-secret"
  value        = azuread_application_password.datahub_app_secret_devops.value
  key_vault_id = azurerm_key_vault.datahub_key_vault.id

  lifecycle {
    ignore_changes = [value]
  }

  depends_on = [azurerm_role_assignment.kv_role_creator]
}

resource "azurerm_key_vault_secret" "datahub_create_graph_user_url" {
  name         = "datahub-create-graph-user-url"
  value        = "-"
  key_vault_id = azurerm_key_vault.datahub_key_vault.id

  lifecycle {
    ignore_changes = [value]
  }

  depends_on = [azurerm_role_assignment.kv_role_creator]
}

resource "azurerm_key_vault_secret" "datahub_infrastructure_repo_url" {
  name         = "datahub-infrastructure-repo-url"
  value        = "-"
  key_vault_id = azurerm_key_vault.datahub_key_vault.id

  lifecycle {
    ignore_changes = [value]
  }

  depends_on = [azurerm_role_assignment.kv_role_creator]
}

resource "azurerm_key_vault_secret" "datahub_infrastructure_repo_username" {
  name         = "datahub-infrastructure-repo-username"
  value        = "-"
  key_vault_id = azurerm_key_vault.datahub_key_vault.id

  lifecycle {
    ignore_changes = [value]
  }

  depends_on = [azurerm_role_assignment.kv_role_creator]
}

resource "azurerm_key_vault_secret" "datahub_infrastructure_repo_password" {
  name         = "datahub-infrastructure-repo-password"
  value        = "-"
  key_vault_id = azurerm_key_vault.datahub_key_vault.id

  lifecycle {
    ignore_changes = [value]
  }

  depends_on = [azurerm_role_assignment.kv_role_creator]
}

resource "azurerm_key_vault_secret" "datahub_infrastructure_repo_pr_url" {
  name         = "datahub-infrastructure-repo-pr-url"
  value        = "-"
  key_vault_id = azurerm_key_vault.datahub_key_vault.id

  lifecycle {
    ignore_changes = [value]
  }

  depends_on = [azurerm_role_assignment.kv_role_creator]
}

resource "azurerm_key_vault_secret" "datahub_infrastructure_repo_pr_browser_url" {
  name         = "datahub-infrastructure-repo-pr-browser-url"
  value        = "-"
  key_vault_id = azurerm_key_vault.datahub_key_vault.id

  lifecycle {
    ignore_changes = [value]
  }

  depends_on = [azurerm_role_assignment.kv_role_creator]
}

