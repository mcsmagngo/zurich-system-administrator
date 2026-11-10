output "workspace_resource_ids" {
  value = {
    production  = module.databricks_production.workspace_id
    development = module.databricks_development.workspace_id
  }
  description = "Use these resource IDs in the separate Private Link foundation deployment."
}

output "workspace_hostnames" {
  value = {
    production  = module.databricks_production.workspace_hostname
    development = module.databricks_development.workspace_hostname
  }
  description = "Private DNS and Private Endpoint configuration must precede access."
}
