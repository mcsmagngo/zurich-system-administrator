# Zurich System Administrator — Simplified Terraform (Option B)

**Scope:** One reusable Terraform module, `modules/databricks`, provisions an Azure Databricks **Premium workspace with VNet injection**. Separate small root configurations under `environments/prod` and `environments/dev` call the **same** module. They must have distinct Terraform states and different Azure subscriptions.

This is a technical case-study submission, **not** a deployable production environment without approved prerequisites. The attached architecture diagram and technical document describe the whole solution. This Terraform intentionally implements **only Option B** of the assignment.

## Why simpler?

- No `var.development` or `var.production` object to enter interactively.
- No two aliased providers in one root configuration.
- Just one reusable resource module and four required inputs per environment.
- Workspace name, managed resource-group name and subnet names follow declared naming assumptions.
- The NSG-association resource IDs are derived from the subnet IDs (as documented by the AzureRM provider).

## Directory structure

```text
modules/databricks/main.tf

environments/prod/main.tf
environments/prod/terraform.tfvars.example

environments/dev/main.tf
environments/dev/terraform.tfvars.example
```

## Requirements / external prerequisites

Before any real deployment, the owning Azure teams must confirm:

1. One real Prod subscription and a separate Dev subscription in the shared Entra tenant, with suitable permissions and **independent state backends**.
2. Existing resource group, approved region and spoke VNet in each subscription.
3. Two separate subnet names per environment: `snet-adb-host-<env>` and `snet-adb-container-<env>`, each delegated to `Microsoft.Databricks/workspaces` and associated with an NSG. NSGs/UDRs must allow required Databricks platform traffic while routing approved API egress through the Hub Firewall.
4. An Azure Databricks Access Connector with approved managed identity and permissions for the workspace-managed storage firewall feature.
5. **Private Link configuration outside this module**, including front-end and back-end workspace private endpoints, browser authentication, DNS and routes required for private-only access.
6. Private endpoints and DNS for the three production ADLS Gen2 accounts (both `blob` and `dfs` as required), Key Vault and existing cross-subscription Azure SQL Database; public data access disabled.
7. Entra groups, Unity Catalog data privileges, Key Vault rotation, audit, monitoring, cost controls and production DR are defined in the design document but are **outside Option B's Terraform scope**.
8. The assumed `brazilsouth` region, resource names, CIDR plan and data-residency requirements must be confirmed.

> Disabling public workspace access without functional private endpoints will make the workspace inaccessible. Do not apply in a live environment until the private foundation is ready and approved.

## Local validation on macOS

From the directory containing this README:

```bash
terraform fmt -recursive
terraform -chdir=environments/prod init -backend=false
terraform -chdir=environments/prod validate
terraform -chdir=environments/dev init -backend=false
terraform -chdir=environments/dev validate
```

`terraform validate` tests Terraform configuration consistency, **not** the existence of cloud prerequisites. Initialization downloads the provider and does not provision Azure resources.

## Plan only after authorized Azure credentials and real prerequisites

Work separately in each environment. For example, in the PROD folder copy `terraform.tfvars.example` to `terraform.tfvars`, replace every placeholder with real approved IDs, and configure the required Azure identity. A real `terraform plan` needs cloud access. For an assessed case study, local validation may be sufficient; **do not apply** to an organization's subscriptions without authorization.

The two root directories are independent. For real deployment, configure a secure remote Terraform state per environment and protect it with RBAC, encryption and state locking. Never put Dev and Prod into the same state or run a PROD plan against the Dev state.

## Security rationale

The module intentionally keeps:

- `public_network_access_enabled = false` for private-only workspace access;
- `network_security_group_rules_required = "NoAzureDatabricksRules"` for the chosen private control-plane approach;
- `no_public_ip = true` for clusters;
- `default_storage_firewall_enabled = true` and a pre-existing Access Connector;
- separate subscriptions and consistent environment tags.

It intentionally does **not** provision the Hub Firewall, private endpoints, private DNS, Key Vault, Storage Accounts, SQL, RBAC or disaster recovery because the brief allows **one Terraform module only**. Those decisions are described in the accompanying PDF and diagram.

## References

- Terraform AzureRM `azurerm_databricks_workspace`: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace
- Azure Databricks VNet injection: https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/vnet-inject
- Azure Databricks Private Link: https://learn.microsoft.com/en-us/azure/databricks/security/network/concepts/private-link
