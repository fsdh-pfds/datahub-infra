output "location" {
  value = azurerm_resource_group.sp_hub_rg.location
}

output "public_ip_address" {
  value = azurerm_public_ip.datahub_public_ip.ip_address
}