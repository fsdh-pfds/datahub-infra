# Service Principal and App Registration
# Also reference https://learn.microsoft.com/en-us/graph/permissions-reference

resource "azuread_application" "datahub_app_registration_core" {
  display_name     = "${var.resource_prefix}-core-${var.environment_name}"
  owners           = [data.azurerm_client_config.current.object_id]
  sign_in_audience = "AzureADMultipleOrgs"

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph
    resource_access {
      id   = "0e263e50-5827-48a4-b97c-d940288653c7" # Directory.AccessAsUser.All Delegated
      type = "Scope"
    }
    resource_access {
      id   = "06da0dbc-49e2-44d2-8312-53f166ab848a" # Directory.Read.All	Delegated      	
      type = "Scope"
    }
    resource_access {
      id   = "7ab1d382-f21e-4acd-a863-ba3e13f7da61" # Directory.Read.All	Application    	
      type = "Role"
    }
    resource_access {
      id   = "09850681-111b-4a89-9bed-3f2cae46d706" # User.Invite.All	Application
      type = "Role"
    }
    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read	Delegated	
      type = "Scope"
    }
    resource_access {
      id   = "a154be20-db9c-4678-8ab7-66f6cc099a59" # User.Read.All	Delegated
      type = "Scope"
    }
    resource_access {
      id   = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All	Application	
      type = "Role"
    }
    resource_access {
      id   = "b340eb25-3456-403f-be2f-af7a0d370277" # User.ReadBasic.All	Delegated	
      type = "Scope"
    }
  }

  feature_tags {
    enterprise = true
    gallery    = true
  }

  web {
    homepage_url  = "https://${local.app_service_name}.azurewebsites.net"
    redirect_uris = ["https://localhost:5001/signin-oidc", "https://${local.app_service_name}.azurewebsites.net/signin-oidc"]

    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = true
    }
  }
}

resource "azuread_application" "datahub_app_registration_devops" {
  display_name     = "${var.resource_prefix}-devops-${var.environment_name}"
  owners           = [data.azurerm_client_config.current.object_id]
  sign_in_audience = "AzureADMultipleOrgs"

  feature_tags {
    enterprise = true
    gallery    = true
  }

  web {
    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = true
    }
  }
}

resource "time_rotating" "datahub_rotation_365d" {
  rotation_days = 365
}

resource "azuread_application_password" "datahub_app_secret_core" {
  display_name          = "auto-created by Terraform"
  application_object_id = azuread_application.datahub_app_registration_core.object_id
  rotate_when_changed = {
    rotation = time_rotating.datahub_rotation_365d.id
  }
}

resource "azuread_application_password" "datahub_app_secret_devops" {
  display_name          = "auto-created by Terraform"
  application_object_id = azuread_application.datahub_app_registration_devops.object_id
  rotate_when_changed = {
    rotation = time_rotating.datahub_rotation_365d.id
  }
}
