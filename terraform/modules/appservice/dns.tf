resource "azurerm_dns_cname_record" "datahub_app_cname" {
  count = var.azure_dns_record == "" ? 0 : 1

  name                = var.azure_dns_record
  zone_name           = var.azure_dns_zone_name
  resource_group_name = var.azure_dns_zone_rg
  ttl                 = 120
  record              = azurerm_linux_web_app.datahub_portal_app_service.default_hostname
}

resource "azurerm_dns_txt_record" "datahub_dns_txt_record" {
  name                = "asuid.${var.azure_dns_record}.${var.azure_dns_zone_name}"
  zone_name           = var.azure_dns_zone_name
  resource_group_name = var.azure_dns_zone_rg
  ttl                 = 120
  record {
    value = azurerm_linux_web_app.datahub_portal_app_service.custom_domain_verification_id
  }
}

resource "time_sleep" "wait_for_dns_txt" {
  depends_on = [azurerm_dns_txt_record.datahub_dns_txt_record, azurerm_dns_cname_record.datahub_app_cname]

  create_duration = "125s"
}

resource "azurerm_app_service_custom_hostname_binding" "datahub_app_custom_host" {
  count = var.azure_dns_record == "" ? 0 : 1

  hostname            = "${var.azure_dns_record}.${var.azure_dns_zone_name}"
  app_service_name    = azurerm_linux_web_app.datahub_portal_app_service.name
  resource_group_name = var.az_resource_group

  depends_on = [time_sleep.wait_for_dns_txt]
  lifecycle {
    ignore_changes = [ssl_state, thumbprint]
  }
}

# If getting error, temporarily comment out this resource and run to completion before re-enabling
resource "azurerm_app_service_certificate_binding" "datahub_ssl_binding" {
  count = var.ssl_cert_name == "" ? 0 : 1

  hostname_binding_id = azurerm_app_service_custom_hostname_binding.datahub_app_custom_host[0].id
  certificate_id      = azurerm_app_service_certificate.datahub_ssl_cert[0].id
  ssl_state           = "SniEnabled"
}

data "azurerm_key_vault_secret" "datahub_ssl_cert" {
  count = var.ssl_cert_name == "" ? 0 : 1

  name         = var.ssl_cert_name
  key_vault_id = var.ssl_cert_kv_id
}

resource "azurerm_app_service_certificate" "datahub_ssl_cert" {
  count = var.ssl_cert_name == "" ? 0 : 1

  name                = "datahub-app-cert-kv"
  resource_group_name = var.az_resource_group
  location            = var.az_region
  pfx_blob            = data.azurerm_key_vault_secret.datahub_ssl_cert[0].value

  depends_on = [time_sleep.wait_for_dns_txt]

  tags = merge(
    var.common_tags
  )

  lifecycle {
    ignore_changes = [pfx_blob]
  }
}
