variable "workspace_name" {
  description = "Globally unique Databricks workspace name within the applicable Azure scope."
  type        = string
}
variable "managed_resource_group_name" {
  description = "Resource group Databricks will create for workspace-managed infrastructure."
  type        = string
}
variable "resource_group_name" {
  description = "Existing customer-managed resource group."
  type        = string
}
variable "location" {
  description = "Azure region of the workspace and its injected VNet."
  type        = string
}
variable "virtual_network_id" {
  description = "Existing spoke VNet resource ID."
  type        = string
}
variable "host_subnet_name" {
  description = "Existing Databricks delegated host ('public') subnet; no public IPs are assigned."
  type        = string
}
variable "container_subnet_name" {
  description = "Existing Databricks delegated container ('private') subnet."
  type        = string
}
variable "host_subnet_nsg_association_id" {
  description = "ID of the existing NSG association on the host subnet (often equal to subnet resource ID)."
  type        = string
}
variable "container_subnet_nsg_association_id" {
  description = "ID of the existing NSG association on the container subnet (often equal to subnet resource ID)."
  type        = string
}
variable "access_connector_id" {
  description = "Existing Databricks Access Connector with managed identity outside the managed resource group. Required to protect workspace root storage."
  type        = string
}
variable "tags" {
  description = "Common platform, owner, environment and cost center tags."
  type        = map(string)
}
