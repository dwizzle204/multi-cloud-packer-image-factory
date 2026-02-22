# Copilot instructions

This repository is a public multi-cloud image factory template. Keep suggestions safe, generic, and reusable.

## Core principles

- Treat this repo as a template, not an organization-specific implementation.
- Never introduce secrets, account IDs, private hostnames, or internal URLs.
- Keep promotion metadata-only (no rebuild during promotion).
- Keep separation of concerns:
  - Packer builds images
  - Ansible configures OS
  - CIS roles harden
  - GitHub Actions orchestrates lifecycle

## Workflow expectations

- Prefer deterministic versions over `latest`.
- Preserve OIDC-based auth patterns in workflows.
- Keep matrix behavior (`os x cloud`) in build/retention workflows.
- Keep Terratest and SARIF features opt-in/optional where practical.

## Packer and Ansible expectations

- Use HCL2.
- Keep multi-builder layout for AWS, Azure, GCP.
- Preserve metadata fields:
  - `image_name`
  - `image_version`
  - `git_sha`
  - `build_date`
  - `channel`
- Keep CIS role sources:
  - `ansible-lockdown.rhel9_cis`
  - `ansible-lockdown.windows_2022_cis`

## Documentation expectations

- Keep docs public-safe and vendor-neutral.
- If behavior changes, update:
  - `README.md`
  - `SETUP_GUIDE.md`
  - `TEMPLATE_USAGE.md`
  - `docs/workflow-variables.md`
  - `CHANGELOG.md`
  - `VERSION` (for release-affecting updates)

## Testing expectations

- Keep static checks runnable via `make test`.
- Keep Terratest examples environment-gated and safe-by-default.
