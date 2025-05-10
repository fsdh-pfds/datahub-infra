resource "azurerm_key_vault_secret" "datahub_search" {
  name         = "datahub-search-secret"
  value        = azurerm_search_service.datahub_search.primary_key
  key_vault_id = var.key_vault_id
}