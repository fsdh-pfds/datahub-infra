resource "null_resource" "app_service_vnet_cli" {
  provisioner "local-exec" {
    command    = "az webapp vnet-integration add -g ${var.az_resource_group} -n ${var.app_service_name} --vnet ${azurerm_virtual_network.datahub_vnet.name} --subnet ${azurerm_subnet.subnet_app.name}"
    on_failure = continue
  }

  triggers = {
    always_run = "${timestamp()}"
  }

  depends_on = [azurerm_app_service_virtual_network_swift_connection.datahub_app_vnet]
}

resource "null_resource" "function_app_vnet_cli" {
  provisioner "local-exec" {
    command    = "az webapp vnet-integration add -g ${var.az_resource_group} -n ${var.function_app_name} --vnet ${azurerm_virtual_network.datahub_vnet.name} --subnet ${azurerm_subnet.subnet_app.name}"
    on_failure = continue
  }

  triggers = {
    always_run = "${timestamp()}"
  }

  depends_on = [azurerm_app_service_virtual_network_swift_connection.datahub_app_vnet]
}

resource "null_resource" "func_app_res_prov_vnet" {
  provisioner "local-exec" {
    command    = "az webapp vnet-integration add -g ${var.az_resource_group} -n ${var.function_app_name_res_prov} --vnet ${azurerm_virtual_network.datahub_vnet.name} --subnet ${azurerm_subnet.subnet_app.name}"
    on_failure = continue
  }

  triggers = {
    always_run = "${timestamp()}"
  }

  depends_on = [azurerm_app_service_virtual_network_swift_connection.datahub_app_vnet]
}

resource "null_resource" "func_app_py_vnet" {
  provisioner "local-exec" {
    command    = "az webapp vnet-integration add -g ${var.az_resource_group} -n ${var.function_app_name_py} --vnet ${azurerm_virtual_network.datahub_vnet.name} --subnet ${azurerm_subnet.subnet_app.name}"
    on_failure = continue
  }

  triggers = {
    always_run = "${timestamp()}"
  }

  depends_on = [azurerm_app_service_virtual_network_swift_connection.datahub_app_vnet]
}

resource "azurerm_mssql_virtual_network_rule" "mssql_vnet_rule" {
  name      = "${var.resource_prefix}-${var.environment_name}-mssql-vnet-rule-app"
  server_id = var.mssql_id
  subnet_id = azurerm_subnet.subnet_app.id
}

resource "null_resource" "func_app_res_prov_settings" {
  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = <<-EOT
      $appserviceOutboundIP="${azurerm_public_ip.datahub_public_ip.ip_address}"
      az webapp config appsettings set -n ${var.function_app_name_res_prov} -g ${var.az_resource_group} --settings allow_souce_ip=$appserviceOutboundIP
      az webapp config appsettings set -n ${var.function_app_name_res_prov} -g ${var.az_resource_group} --settings Terraform__Variables__allow_source_ip=$appserviceOutboundIP
    EOT
    on_failure  = fail
  }

  triggers = { always_run = "${timestamp()}" }
}
