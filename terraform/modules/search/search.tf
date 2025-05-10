
resource "azurerm_search_service" "datahub_search" {
  name                = local.search_name
  location            = var.az_region
  resource_group_name = var.az_resource_group
  sku                 = "basic"

  tags = merge(
    var.common_tags
  )

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [allowed_ips]
  }
}

# resource "null_resource" "filemetadata-index" {
#   provisioner "local-exec" {
#     interpreter = ["pwsh", "-Command"]
#     command     = <<-EOF
#       az rest -m put -u "https://${azurerm_search_service.datahub_search.name}.search.windows.net/indexes/filemetadata-index?api-version=2020-06-30" --headers "api-key=${azurerm_search_service.datahub_search.primary_key} Content-Type=application/json" --body @res\filemetadata-index.json
#     EOF
#     on_failure = fail
#   }
# }

# resource "null_resource" "datahubdlgen2datasource" {
#   provisioner "local-exec" {
#     command    = "cp res/datahubdlgen2datasource.json ds.json; sed -i \"s|###BLOB_NAME#|${data.azurerm_storage_account.datahub_datalake_gen2.name}|\" ds.json;sed -i \"s|###BLOB_KEY#|${data.azurerm_storage_account.datahub_datalake_gen2.primary_access_key}|\" ds.json; az rest -m post -u https://${azurerm_search_service.datahub_search.name}.search.windows.net/datasources?api-version=2020-06-30 --headers \"api-key=${azurerm_search_service.datahub_search.primary_key}\" --body @ds.json;rm -f ds.json"
#     on_failure = continue
#   }
# }
