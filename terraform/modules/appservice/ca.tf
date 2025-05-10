resource "null_resource" "gc_ca_cert" {
  provisioner "local-exec" {
    command    = <<-EOT
      echo '' | openssl s_client -showcerts -connect www.canada.ca:443 | sed -n -e '/-.BEGIN/,/-.END/ p' > ${path.module}/${local.gc_cert}
    EOT
    on_failure = fail
  }

  triggers = { always_run = "${timestamp()}" }
}

data "local_file" "gc_ca_cert" {
  filename = "${path.module}/${local.gc_cert}"

  depends_on = [null_resource.gc_ca_cert]
}

resource "azurerm_key_vault_secret" "secret_gc_ca_cert" {
  name         = "gc-ca-cert"
  value        = data.local_file.gc_ca_cert.content_base64
  key_vault_id = var.key_vault_id
}

resource "azurerm_app_service_public_certificate" "datahub_portal_app_gc_cert" {
  resource_group_name  = var.az_resource_group
  app_service_name     = azurerm_linux_web_app.datahub_portal_app_service.name
  certificate_name     = "gc-cert"
  certificate_location = "Unknown"
  blob                 = data.local_file.gc_ca_cert.content_base64
}

resource "azurerm_app_service_public_certificate" "datahub_dotnet_func_gc_cert" {
  resource_group_name  = var.az_resource_group
  app_service_name     = azurerm_linux_function_app.datahub_function_dotnet.name
  certificate_name     = "gc-cert"
  certificate_location = "Unknown"
  blob                 = data.local_file.gc_ca_cert.content_base64
}

resource "azurerm_app_service_public_certificate" "datahub_resprov_func_gc_cert" {
  resource_group_name  = var.az_resource_group
  app_service_name     = azurerm_linux_function_app.res_prov_function_dotnet.name
  certificate_name     = "gc-cert"
  certificate_location = "Unknown"
  blob                 = data.local_file.gc_ca_cert.content_base64
}

resource "azurerm_app_service_public_certificate" "datahub_python_func_gc_cert" {
  resource_group_name  = var.az_resource_group
  app_service_name     = azurerm_linux_function_app.datahub_function_py.name
  certificate_name     = "gc-cert"
  certificate_location = "Unknown"
  blob                 = data.local_file.gc_ca_cert.content_base64
}
