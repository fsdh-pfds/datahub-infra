provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
  skip_provider_registration = "true"
  subscription_id            = "bc4bcb08-d617-49f4-b6af-69d6f10c240b"
}

provider "random" {}

terraform {
  backend "azurerm" {
    resource_group_name  = "sp-datahub-iac-rg"
    storage_account_name = "sscdataterraformbackend"
    container_name       = "dhportal"
    key                  = "terraform.tfstate.dev.preinstall"
  }
}

module "main" {
  source             = "../../main"
  az_subscription_id = "bc4bcb08-d617-49f4-b6af-69d6f10c240b"
  az_tenant_id       = "8c1a4d93-d828-4d0e-9303-fd3bd611c822"
  environment_name   = "dev"
  resource_prefix    = "fsdh"
  support_email      = "DataSolutions-Solutiondedonnees@ssc-spc.gc.ca"
}
