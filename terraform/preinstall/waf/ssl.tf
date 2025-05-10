


resource "azurerm_key_vault_certificate" "datahub_waf_ssl_cert" {
  name         = "datahub-waf-ssl-cert"
  key_vault_id = var.key_vault_id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"] # Server Authentication = 1.3.6.1.5.5.7.3.1 # Client Authentication = 1.3.6.1.5.5.7.3.2

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = local.domain_dns_san
      }

      subject            = "CN=${local.domain_dns_main}"
      validity_in_months = 12
    }
  }

  lifecycle {
    ignore_changes = all
  }
}

