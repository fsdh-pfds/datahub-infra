locals {
  config_value = {
    tenant_id           = var.az_tenant_id
    log_workspace_id    = var.log_workspace_id
    sp_client_id        = var.global_var.secret_name.sp_client_id
    sp_client_secret    = var.global_var.secret_name.sp_client_secret
    app_insights_key    = var.app_insights_key
    smtp_host           = var.smtp_host
    SmtpPort            = var.smtp_port
    smtp_sender_name    = var.smtp_sender_name
    smtp_sender_address = var.smtp_sender_address
    smtp_username       = var.global_var.secret_name.smtp_username
    smtp_password       = var.global_var.secret_name.smtp_password
  }
}

