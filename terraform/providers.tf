# Authentication: use federated identity from private Azure DevOps agents.
# Do not place client secrets, tokens or sensitive data in tfvars or state.
provider "azurerm" {
  alias           = "prod"
  subscription_id = var.production_subscription_id
  features {}
}

provider "azurerm" {
  alias           = "dev"
  subscription_id = var.development_subscription_id
  features {}
}
