terraform {
  backend "azurerm" {
    resource_group_name  = resource_group_name
    storage_account_name = storage_account_name
    container_name       = container_name
    key                  = key
  }
}

module "main" {
  source                  = "../../main"
  az_subscription_id      = az_subscription_id
  az_tenant_id            = az_tenant_id
  az_resource_group       = az_resource_group
  key_vault_name          = key_vault_name
  key_vault_id            = key_vault_id
  environment_name        = environment_name
  app_alt_domain          = app_alt_domain
  app_create_slot         = app_create_slot
  external_dns            = external_dns
  aad_domain              = aad_domain
  support_email           = support_email
  aad_group_admin         = aad_group_admin
  aad_group_dba_name      = aad_group_dba_name
  powerbi_url_spi         = powerbi_url_spi
  powerbi_pdf_base_url    = powerbi_pdf_base_url
  smtp_sender_name        = smtp_sender_name
  smtp_sender_address     = smtp_sender_address
  opendata_approver_name  = opendata_approver_name
  opendata_approver_email = opendata_approver_email
  opendata_api_url        = opendata_api_url
  azure_use_msi           = azure_use_msi
  send_alert_email        = send_alert_email
  azure_databricks_sp     = azure_databricks_sp
  default_user_group      = default_user_group
}
