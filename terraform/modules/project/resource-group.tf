
resource "azurerm_resource_group" "datahub_project_rg" {
  name     = local.resource_group_name
  location = local.resource_group_region

  tags = merge(
    var.common_tags
  )

  lifecycle {
    prevent_destroy = false
  }
}
