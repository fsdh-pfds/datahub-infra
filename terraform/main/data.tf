data "azurerm_key_vault" "datahub_key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.az_resource_group
}
