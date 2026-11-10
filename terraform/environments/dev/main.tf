# Root configuration for DEV ONLY; each environment has a separate state.
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

variable "subscription_id" { type = string }
variable "resource_group_name" { type = string }
variable "vnet_id" { type = string }
variable "access_connector_id" { type = string }
variable "location" {
  type    = string
  default = "brazilsouth" # Assumption; validate the approved region.
}

module "databricks" {
  source              = "../../modules/databricks"
  environment         = "dev"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_id             = var.vnet_id
  access_connector_id = var.access_connector_id
}
