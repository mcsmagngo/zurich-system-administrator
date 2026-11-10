# Zurich System Administrator | ZCAM LATAM Hub — working package

This package is an **example** to help reproduce and explain the technical assignment; it is not an Azure deployment or a final verified company architecture.

**Terraform tutorial:** `README_Terraform.md`.

**Sample deliverables in English:**
1. `architecture/Zurich_Azure_Architecture_Terraform` (also `.drawio` and `.pdf`).
2. `document/Zurich_Technical_Design_Terraform.pdf` (5 pages).
3. `terraform/` (one custom Terraform module, Option B, called once each for prod/dev; prerequisite Azure infrastructure is out of scope).

All budgets, CIDRs, architecture assumptions, DR targets, external SQL permissions, and private network dependencies require validation in the actual tenant. The sample Terraform has **not** been run against Azure, and local provider validation may require Internet access and installed Terraform.

**Confidentiality:** The original assignment is marked `INTERNAL USE ONLY`; keep the material in an authorized private Git repository. Do not publish the original assignment or credentials publicly.
