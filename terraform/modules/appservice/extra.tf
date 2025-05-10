resource "null_resource" "app_service_extra_settings" {
  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = <<-EOT
      $DATE_CODE=(Get-Date -Format "yyyyMMdd-HHmm")
      az webapp config appsettings set -n ${azurerm_linux_web_app.datahub_portal_app_service.name} -g ${var.az_resource_group} --settings DATE_CREATED=$DATE_CODE
    EOT
    on_failure  = fail
  }
}

resource "null_resource" "common_tags_settings" {
  for_each = var.common_tags

  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = <<-EOT
      sleep $(30 * ${index(keys(var.common_tags), each.key)})
      az webapp config appsettings set -n ${azurerm_linux_function_app.res_prov_function_dotnet.name} -g ${var.az_resource_group} --settings Terraform__Variables__common_tags__${each.key}="${each.value}" | out-null
    EOT
    on_failure  = fail
  }
}

resource "azurerm_linux_web_app_slot" "datahub_portal_app_service_slot_downtime" {
  name           = "downtime"
  app_service_id = azurerm_linux_web_app.datahub_portal_app_service.id

  site_config {
    always_on              = var.app_service_always_on
    vnet_route_all_enabled = true
    websockets_enabled     = true
    http2_enabled          = true
    default_documents      = ["maintenance-page.html"]
    application_stack {
      dotnet_version = "8.0"

    }
  }

  tags = merge(
    var.common_tags
  )
}
