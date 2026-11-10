# Option B from the assignment: ONE reusable module, instantiated once per
# existing Azure subscription. All networking and Private Link foundations
# are prerequisites outside the scope of the submitted Terraform module.
module "databricks_production" {
  source    = "./modules/databricks_workspace"
  providers = { azurerm = azurerm.prod }

  workspace_name                   = var.production.workspace_name
  managed_resource_group_name      = var.production.managed_resource_group
  resource_group_name              = var.production.resource_group_name
  location                         = var.production.location
  virtual_network_id               = var.production.virtual_network_id
  host_subnet_name                 = var.production.host_subnet_name
  container_subnet_name            = var.production.container_subnet_name
  host_subnet_nsg_association_id   = var.production.host_subnet_nsg_assoc_id
  container_subnet_nsg_association_id = var.production.container_subnet_nsg_assoc_id
  access_connector_id              = var.production.access_connector_id
  tags                             = merge(var.common_tags, { environment = "production", data_classification = "restricted" })
}

module "databricks_development" {
  source    = "./modules/databricks_workspace"
  providers = { azurerm = azurerm.dev }

  workspace_name                   = var.development.workspace_name
  managed_resource_group_name      = var.development.managed_resource_group
  resource_group_name              = var.development.resource_group_name
  location                         = var.development.location
  virtual_network_id               = var.development.virtual_network_id
  host_subnet_name                 = var.development.host_subnet_name
  container_subnet_name            = var.development.container_subnet_name
  host_subnet_nsg_association_id   = var.development.host_subnet_nsg_assoc_id
  container_subnet_nsg_association_id = var.development.container_subnet_nsg_assoc_id
  access_connector_id              = var.development.access_connector_id
  tags                             = merge(var.common_tags, { environment = "development", data_classification = "synthetic-only" })
}
