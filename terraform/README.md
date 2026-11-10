# ZCAM LATAM Hub - Azure Databricks workspace (Terraform option B)

This is **one reusable Terraform module** for **Option B** of the Zurich System Administrator case. It is called once for the production subscription and once for the development subscription. Both calls instantiate the same `modules/databricks_workspace` module. All configuration and identifiers are examples only; no resources have been deployed.

## Design scope

Provision a **Premium Azure Databricks workspace with customer VNet injection** in each environment, with:

- **No public IPs** on classic compute (`no_public_ip = true`).
- **Public network access disabled** on the workspace.
- **Backend Private Link policy** (`NoAzureDatabricksRules`).
- **Workspace root storage firewall enabled** using an **existing Databricks Access Connector**.
- Mandatory tags for ownership and cost attribution.

This Terraform **does not** create networking, secrets, data stores, firewall, endpoints, SQL, DR workspaces, pipelines or Key Vault. Those are documented design elements **outside the single-module implementation choice**. Do not interpret a successful workspace creation as a functioning, secured end-to-end platform.

## Prerequisites - set up before Terraform apply

1. Existing **production and development subscriptions** under the same Microsoft Entra tenant; authenticated private build agent/service connection with least-privilege roles.
2. Separate **production and development VNets** with reachable Hub and no overlapping address spaces.
3. Two **distinct delegated subnets** per VNet (`Microsoft.Databricks/workspaces`): host (public *name* does not mean public IP) and container (private). Attach NSGs and retain provider-required rules. Configure the route tables/egress to the existing Hub Azure Firewall. Verify required Databricks service traffic through the private endpoints.
4. An independent **Databricks Access Connector** in each subscription; grant minimum data permissions to approved storage. Do not put this connector in the managed resource group.
5. Workspace resource groups and planned managed resource group names.
6. **Private DNS and Private Link design** approved by networking: front-end workspace endpoint (`databricks_ui_api`) in the Hub transit subnet, back-end workspace endpoint (`databricks_ui_api`) in the spoke, plus shared regional `browser_authentication` endpoint. Validate endpoint/DNS configuration for current platform support and service requirements; do not disable/change production routes casually.
7. Approved capacity/quota and policy exceptions for private Databricks deployment.

## Safe staged rollout

**Stage A (foundation, NOT in this module):** build peering, delegated subnets, NSGs, UDRs, Firewall DNS routing, DNS Private Resolver, logging, Access Connectors, Key Vault, data storage and SQL private connectivity. Prepare the shared browser SSO endpoint; create/validate PEs when target workspaces exist.

**Stage B (this module):** provision the two workspaces. They are *intentionally inaccessible until required endpoints and DNS are provisioned*. Complete workspace storage `blob` + `dfs` private endpoints before allowing workloads.

**Stage C (foundation, NOT in this module):** create private endpoints and DNS records for workspace front/back, managed workspace root storage, raw/curated/analytics storage, Key Vault and production SQL. Turn off public network access on all data resources after validating private paths. Configure Unity Catalog storage credentials/external locations and Entra group access. Validate `nslookup`, egress, jobs and blocked-public-access tests.

**Stage D (operations):** configure Azure DevOps private agents, job/compute policies, budgets, alerting, Key Vault rotation, controlled egress and DR testing.

## Usage

```
cp terraform.tfvars.example terraform.tfvars
# Replace every sample resource/subscription ID and cost center with real values.
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan -out=tfplan
# After network/security owner review only:
terraform apply tfplan
```

Run from a **private Azure DevOps agent** with workload identity federation. Store Terraform **remote state in private Azure Storage** with encryption, RBAC, private endpoint, versioning, locking and state access auditing. Terraform state can contain sensitive metadata. Do not commit `terraform.tfvars`, state or plan files.

**Important:** `.tfvars` is deliberately excluded from Git. The `terraform.tfvars.example` file contains only placeholders. `terraform plan` and `apply` require actual subscriptions, existing resources, permissions and approved configuration. This submission has not been applied to Azure.

## Environments and data boundaries

- Production reads `stlatamraw`, `stlatamcurated` (PII), `stlatamanalytics`, plus the Azure SQL Database in the other subscription via an approved private endpoint; no public PII paths.
- Development **never reads production PII or production SQL**; use synthetic/de-identified data in dev equivalents. External API ingestion HTTPS egress is restricted to two approved FQDNs through the existing Azure Firewall and must not carry PII.
- Classic VNet-injected compute only in the initial deployment; serverless would need independently evaluated Network Connectivity Configuration private endpoints.

## Why module B?

Option B explicitly tests Azure Databricks secure workspace configuration and VNet injection, the center of the business case. The design diagram and 8-page technical document describe platform dependencies intentionally outside the single-module IaC boundary.

## Limitations

- No live Azure tenancy, credentials, pricing agreement, quotas or full acceptance-test results were provided. Numbers in the technical document are **planning allowances**, not quotes.
- The `RPO <= 4 h / RTO <= 2 h` objectives are **design targets only** until timed failover/recovery drills prove them. SQL/database DR arrangements need separate owner approval.
- Running `terraform validate` still depends on a locally available Terraform binary and provider plugins; no Azure apply has been performed here.

## References

- https://learn.microsoft.com/en-us/azure/databricks/security/network/concepts/private-link
- https://learn.microsoft.com/en-us/azure/databricks/scenarios/quickstart-create-databricks-workspace-vnet-injection
- https://learn.microsoft.com/en-us/azure/databricks/security/network/storage/firewall-support
- https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace
- https://learn.microsoft.com/en-us/azure/databricks/admin/disaster-recovery
