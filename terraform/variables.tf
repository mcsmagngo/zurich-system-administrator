variable "production_subscription_id" {
  description = "Production Azure subscription ID."
  type        = string
  sensitive   = true
}

variable "development_subscription_id" {
  description = "Development Azure subscription ID."
  type        = string
  sensitive   = true
}

variable "production" {
  description = "Prerequisite networking, NSG associations, resource group and access connector for production."
  type = object({
    workspace_name             = string
    managed_resource_group     = string
    resource_group_name        = string
    location                   = string
    virtual_network_id         = string
    host_subnet_name           = string
    container_subnet_name      = string
    host_subnet_nsg_assoc_id   = string
    container_subnet_nsg_assoc_id = string
    access_connector_id        = string
  })
}

variable "development" {
  description = "Prerequisite networking, NSG associations, resource group and access connector for development."
  type = object({
    workspace_name             = string
    managed_resource_group     = string
    resource_group_name        = string
    location                   = string
    virtual_network_id         = string
    host_subnet_name           = string
    container_subnet_name      = string
    host_subnet_nsg_assoc_id   = string
    container_subnet_nsg_assoc_id = string
    access_connector_id        = string
  })
}

variable "common_tags" {
  description = "Mandatory cost allocation and ownership tags."
  type        = map(string)
  default = {
    business_unit = "ZCAM-LATAM"
    owner         = "data-platform"
    managed_by    = "terraform"
    cost_center   = "set-before-apply"
  }
}
