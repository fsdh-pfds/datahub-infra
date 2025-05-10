provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
  skip_provider_registration = "true"
  subscription_id            = "1ef2f902-ddd2-4920-97c9-4f4c8ac45c36"
}

provider "random" {}

terraform {
  backend "azurerm" {
    resource_group_name  = "dh-base-rg"
    storage_account_name = "dhtfbackend"
    container_name       = "dhportal"
    key                  = "terraform.tfstate.yan.preinstall"
  }
}

module "main" {
  source             = "../../main"
  az_subscription_id = "1ef2f902-ddd2-4920-97c9-4f4c8ac45c36"
  az_tenant_id       = "dcc4e121-5869-4801-88ce-92321102dd99"
  environment_name   = "yan"
  resource_prefix    = "fsdhx"
  support_email      = "swang@apption.com"
}
