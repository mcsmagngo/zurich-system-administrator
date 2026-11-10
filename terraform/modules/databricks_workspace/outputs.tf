output "workspace_id" {
  value       = azurerm_databricks_workspace.this.id
  description = "Workspace Azure resource ID, used when establishing private endpoints."
}

output "workspace_hostname" {
  value       = azurerm_databricks_workspace.this.workspace_url
  description = "Workspace hostname; resolves to a private address after DNS and PE setup."
}
