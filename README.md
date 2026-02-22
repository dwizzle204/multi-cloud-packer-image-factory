# Multi-Cloud Image Factory Template

Public reference template for building hardened golden images across AWS, Azure, and GCP.

Use this repository when you want a reusable starting point for multi-cloud image lifecycle automation (build, test, promote, and retention).

## What this template provides

- Multi-cloud image builds with Packer (HCL2)
- OS configuration with Ansible
- CIS hardening with Ansible Lockdown roles
- GitHub Actions pipelines using OIDC federation (no long-lived cloud keys)
- Lifecycle model: Build -> Test -> Promote -> Retain

This repository is intentionally generic and safe for public use. You must provide your own cloud IDs, permissions, network settings, and naming conventions.

## Supported platforms

- Operating systems:
  - Red Hat Enterprise Linux 9
  - Windows Server 2022
- Cloud targets:
  - AWS (`amazon-ebs`)
  - Azure (`azure-arm`)
  - GCP (`googlecompute`)

## High-level architecture

GitHub Actions orchestrates image lifecycle workflows. Packer builds cloud images, Ansible configures the OS, and Ansible Lockdown applies CIS remediation. Promotion updates image metadata (tags/labels) without rebuilding.

See `docs/architecture.md`.

## Quick start

1. Read `SETUP_GUIDE.md` and complete GitHub OIDC + cloud federation setup.
2. Configure repository variables/secrets from `docs/workflow-variables.md`.
3. Create local image variable files from examples:
   - `images/rhel9/rhel9.auto.pkrvars.hcl`
   - `images/win2022/win2022.auto.pkrvars.hcl`
4. Update cloud identifiers, regions, and base image references.
5. Run GitHub Actions workflow **Image Build**.

## Lifecycle workflows

- **Build** (`image-build.yml`)
  - Builds images by OS x cloud matrix
  - Produces `manifest.json`, `cis-report.json`, and logs as artifacts
  - Optionally runs Terratest
- **Test** (`image-terratest.yml`, `terratest-os-examples.yml`)
  - Provisions lightweight test VMs and runs integration checks
- **Promote** (`image-promote.yml`)
  - Applies `channel=prod` metadata without rebuilding
  - Uses GitHub environment approvals (`prod`)
- **Retain** (`image-retention.yml`)
  - Removes older candidate/prod images by policy (supports dry-run)

## Repository map

- `.github/workflows/` - build, test, promote, retention pipelines
- `images/catalog/images.json` - catalog-driven image definitions used by workflows
- `images/` - Packer templates, shared scripts, and Ansible content
- `scripts/catalog/images.sh` - workflow resolver for catalog selection and matrix generation
- `docs/` - setup, security, architecture, and operations documentation
  - `docs/repository-governance.md` - branch protection and review policy recommendations
- `tests/` - smoke/compliance scripts, Terratest examples, validators
- `CHANGELOG.md` - release notes
- `VERSION` - current template version

## Template notice

This repository is a reusable template and a starting point. It does not include organization-specific hardening exceptions, production access policies, or internal compliance text.
