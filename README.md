# Zurich System Administrator | ZCAM LATAM Hub — working package

This package is an **editable example** to help the candidate reproduce and explain the technical assignment; it is not an Azure deployment or a final verified company architecture.

**Portuguese step-by-step tutorial:** `PASSO_A_PASSO_PTBR.md`.

**Sample deliverables in English:**

1. `architecture/ZCAM_Azure_Architecture.pdf` (also `.png` and `.svg`).
2. `document/ZCAM_Technical_Design_DRAFT.pdf` and `.md` (4 pages; edit and rename before submitting).
3. `terraform/` (one custom Terraform module, Option B, called once each for prod/dev; prerequisite Azure infrastructure is out of scope).

All budgets, CIDRs, architecture assumptions, DR targets, external SQL permissions, and private network dependencies require validation in the actual tenant. The sample Terraform has **not** been run against Azure, and local provider validation may require Internet access and installed Terraform.

**Confidentiality:** The original assignment is marked `INTERNAL USE ONLY`; keep the material in an authorized private Git repository. Do not publish the original assignment or credentials publicly.
