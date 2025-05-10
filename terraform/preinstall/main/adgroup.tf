# AAD Groups
resource "azuread_group" "datahub_admin" {
  display_name     = local.aad_group_admin
  security_enabled = true
}

resource "azuread_group" "datahub_dba" {
  display_name     = local.aad_group_dba_name
  security_enabled = true
}

resource "azuread_group" "datahub_users" {
  display_name     = local.aad_group_users
  security_enabled = true
}
