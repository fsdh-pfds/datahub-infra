output "datahub_vnet_name" {
  value = azurerm_virtual_network.datahub_vnet.name
}

output "datahub_vnet_id" {
  value = azurerm_virtual_network.datahub_vnet.id
}

output "subnet_dbr_pub_name" {
  value = azurerm_subnet.dbr_public.name
}

output "subnet_dbr_prv_name" {
  value = azurerm_subnet.dbr_private.name
}

output "subnet_dbr_pub_id" {
  value = azurerm_subnet.dbr_public.id
}

output "subnet_dbr_prv_id" {
  value = azurerm_subnet.dbr_private.id
}

output "datahub_public_ip_address" {
  value = azurerm_public_ip.datahub_public_ip.ip_address
}

