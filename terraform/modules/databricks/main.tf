# Option B — one reusable module: Azure Databricks with VNet injection.
# Existing networks, delegated subnets, NSGs, access connector and Private Link
# endpoints are prerequisites documented in the technical design.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

variable "environment" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "vnet_id" { type = string }
variable "access_connector_id" { type = string }

locals {
  host_subnet      = "snet-adb-host-${var.environment}"
  container_subnet = "snet-adb-container-${var.environment}"
}

resource "azurerm_databricks_workspace" "this" {
  name                        = "adb-zcam-${var.environment}-brs"
  resource_group_name         = var.resource_group_name
  managed_resource_group_name = "rg-adb-managed-zcam-${var.environment}-brs"
  location                    = var.location
  sku                         = "premium"

  # Private workspace; frontend/backend endpoints are separate prerequisites.
  public_network_access_enabled         = false
  network_security_group_rules_required = "NoAzureDatabricksRules"

  # Protect Databricks managed storage; the Access Connector must already exist.
  default_storage_firewall_enabled = true
  access_connector_id              = var.access_connector_id

  custom_parameters {
    no_public_ip        = true
    virtual_network_id  = var.vnet_id
    public_subnet_name  = local.host_subnet
    private_subnet_name = local.container_subnet

    # For AzureRM, the NSG association ID equals the relevant subnet ID.
    # Both existing subnets MUST be delegated and associated with an NSG.
    public_subnet_network_security_group_association_id  = "${var.vnet_id}/subnets/${local.host_subnet}"
    private_subnet_network_security_group_association_id = "${var.vnet_id}/subnets/${local.container_subnet}"
  }

  tags = {
    project     = "zcam-latam"
    environment = var.environment
    managed_by  = "terraform"
  }
}

output "workspace_id" {
  value = azurerm_databricks_workspace.this.id
}
