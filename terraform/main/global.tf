locals {
  datahub = {
    config_name = {
      tenant_id           = "tenant_id"
      log_workspace_id    = "log_workspace_id"
      sp_client_id        = "sp_client_id"
      sp_client_secret    = "sp_client_secret"
      app_insights_key    = "app_insights_key"
      smtp_host           = "smtp_host"
      smtp_port           = "smtp_port"
      smtp_sender_name    = "smtp_sender_name"
      smtp_sender_address = "smtp_sender_address"
      smtp_username       = "smtp_username"
      smtp_password       = "smtp_password"
      container_backup    = "datahub-backup"
      container_log       = "datahub-app-log"
    }
    secret_name = {
      sp_client_id     = "datahubportal-client-id"
      sp_client_secret = "datahubportal-client-secret"
      smtp_username    = "datahub-smtp-username"
      smtp_password    = "datahub-smtp-password"
    }
  }
}
