resource "azurerm_databricks_workspace" "this" {
  name                        = var.workspace_name
  resource_group_name         = var.resource_group_name
  managed_resource_group_name = var.managed_resource_group_name
  location                    = var.location
  sku                         = "premium"

  # Full private isolation: paired with approved front-end, back-end and
  # browser-authentication private endpoints in the networking foundation.
  public_network_access_enabled         = false
  network_security_group_rules_required = "NoAzureDatabricksRules"

  # Restrict workspace root storage. Foundation must create blob/dfs private
  # endpoints for the managed workspace storage account after deployment.
  default_storage_firewall_enabled = true
  access_connector_id               = var.access_connector_id

  custom_parameters {
    no_public_ip                                      = true
    virtual_network_id                                = var.virtual_network_id
    public_subnet_name                                = var.host_subnet_name
    private_subnet_name                               = var.container_subnet_name
    public_subnet_network_security_group_association_id  = var.host_subnet_nsg_association_id
    private_subnet_network_security_group_association_id = var.container_subnet_nsg_association_id
  }

  tags = var.tags

  lifecycle {
    precondition {
      condition     = var.host_subnet_name != var.container_subnet_name
      error_message = "Host and container subnets must be different."
    }
    precondition {
      condition     = can(regex("/subscriptions/", var.virtual_network_id))
      error_message = "virtual_network_id must be an Azure resource ID."
    }
    precondition {
      condition     = can(regex("/providers/Microsoft.Databricks/accessConnectors/", var.access_connector_id))
      error_message = "access_connector_id must identify a Databricks Access Connector."
    }
  }
}
