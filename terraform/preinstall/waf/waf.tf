locals {
  backend_address_pool_name      = "${azurerm_virtual_network.datahub_vnet.name}-backend-pool"
  backend_address_pool_aks_name  = "${azurerm_virtual_network.datahub_vnet.name}-backend-pool-aks"
  frontend_port_name             = "${azurerm_virtual_network.datahub_vnet.name}-front-port"
  frontend_ip_configuration_name = "${azurerm_virtual_network.datahub_vnet.name}-front-ip"
  backend_http_setting_name      = "${azurerm_virtual_network.datahub_vnet.name}-backend-http"
  listener_name                  = "${azurerm_virtual_network.datahub_vnet.name}-http-listener"
  request_routing_rule_name      = "${azurerm_virtual_network.datahub_vnet.name}-routing"
  request_routing_rule_aks_name  = "${azurerm_virtual_network.datahub_vnet.name}-routing-aks"
  gateway_ip_config_name         = "${azurerm_virtual_network.datahub_vnet.name}-gateway-ip-config"
  ssl_certificate_name           = "${azurerm_virtual_network.datahub_vnet.name}-waf-ssl-cert"
}

resource "azurerm_user_assigned_identity" "datahub_waf_identity" {
  name                = "${var.resource_prefix}-waf-identity-${var.environment_name}"
  location            = data.azurerm_resource_group.datahub_rg.location
  resource_group_name = data.azurerm_resource_group.datahub_rg.name
}

resource "azurerm_application_gateway" "datahub_waf" {
  name                = "${var.resource_prefix}-waf-${var.environment_name}"
  location            = data.azurerm_resource_group.datahub_rg.location
  resource_group_name = data.azurerm_resource_group.datahub_rg.name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_config_name
    subnet_id = data.azurerm_subnet.datahub_subnet_waf.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.datahub_public_ip.id
  }

  dynamic "backend_address_pool" {
    for_each = data.azurerm_linux_web_app.datahub_portal_app_service

    content {
      name  = "${azurerm_virtual_network.datahub_vnet.name}-${backend_address_pool.value.name}-beap"
      fqdns = [backend_address_pool.value.default_site_hostname]
    }
  }

  backend_http_settings {
    name                  = local.backend_http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name           = local.ssl_certificate_name
  }

  dynamic "request_routing_rule" {
    for_each = data.azurerm_linux_web_app.datahub_portal_app_service

    content {
      name                       = local.request_routing_rule_aks_name
      priority                   = 1000
      rule_type                  = "Basic"
      http_listener_name         = local.listener_name
      backend_address_pool_name  = "${azurerm_virtual_network.datahub_vnet.name}-${request_routing_rule.value.name}-beap"
      backend_http_settings_name = local.backend_http_setting_name
    }
  }

  ssl_certificate {
    name                = local.ssl_certificate_name
    key_vault_secret_id = azurerm_key_vault_certificate.datahub_waf_ssl_cert.secret_id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.datahub_waf_identity.id]
  }

  tags = merge(
    var.common_tags
  )

  depends_on = [azurerm_virtual_network.datahub_vnet, azurerm_public_ip.datahub_public_ip]
}

resource "azurerm_role_assignment" "kv_role_waf" {
  for_each = toset(["Key Vault Crypto User", "Key Vault Certificate User"])

  scope                = data.azurerm_key_vault.datahub_key_vault.id
  principal_id         = azurerm_user_assigned_identity.datahub_waf_identity.principal_id
  role_definition_name = each.key
}
