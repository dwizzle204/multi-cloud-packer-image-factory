# Template Usage

Use this repository as a base implementation, then customize it for your organization.

This guide focuses on what to change versus what to keep stable so the template remains maintainable over time.

## How to adopt it

- Option A (recommended): use GitHub **Use this template**
- Option B: fork and maintain your fork with upstream updates

## What you must customize

1. Cloud account/project/subscription identifiers
   AWS account context and IAM role names  
   Azure subscription, resource groups, and optional Compute Gallery names  
   GCP project, service account, image family strategy

2. Regions and placement strategy
   Build and publish regions per cloud  
   Replication strategy (if needed)

3. Image naming and release conventions
   `image_name` standards  
   Retention counts by channel  
   Environment/channel naming strategy

4. Access model and least privilege
   IAM roles (AWS)  
   RBAC assignments (Azure)  
   IAM bindings (GCP)

5. Network and connectivity
   Runner egress paths  
   Package repository reachability  
   WinRM/SSH reachability for testing workflows

6. CIS exceptions and control tuning
   Configure only explicit, documented overrides in:  
   `images/common/ansible/group_vars/rhel9.yml`  
   `images/common/ansible/group_vars/win2022.yml`

## What should remain stable

- CIS role sources:
  - `ansible-lockdown.rhel9_cis`
  - `ansible-lockdown.windows_2022_cis`
- Promotion behavior as metadata change only (no rebuild)
- Versioning format:
  - `YYYY.MM.DD.HHMM.run_number.run_attempt`
- Separation of responsibilities:
  - Packer builds artifacts
  - Ansible configures OS
  - CIS roles enforce security baseline
  - GitHub Actions orchestrates lifecycle

## Recommended extension points

- Add organization agents under `images/common/ansible/roles/common_agents_stub/`
- Add deeper compliance checks under `tests/compliance/`
- Add replication and distribution actions in promotion workflow/scripts
- Add policy gates before promotion (for example Terratest or compliance checks)
