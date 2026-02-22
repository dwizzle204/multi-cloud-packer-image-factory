# Changelog

All notable changes to this template are documented in this file.

## 0.5.1 - 2026-02-22

### Added
- Added reusable build workflow implementation:
  - `.github/workflows/reusable-image-build.yml`
- Added workflow/job concurrency controls to prevent overlapping runs on the same image targets:
  - build, promote, retention, and Terratest workflows
- Added semantic GitHub Actions linting:
  - `tests/ci/lint-workflows.sh` (`actionlint`)
  - integrated into `tests/run-all.sh`

### Changed
- Converted `image-build.yml` into a thin wrapper that calls `reusable-image-build.yml`.
- Added explicit `jq` availability checks in catalog-dependent workflows:
  - `reusable-image-build.yml`
  - `image-promote.yml`
  - `image-retention.yml`
- Replaced invalid workflow expression usage for build timestamp with runtime UTC timestamp generation.
- Updated docs to reflect reusable workflow architecture and linting behavior:
  - `README.md`
  - `docs/workflow-variables.md`
  - `docs/repository-structure.md`
  - `tests/README.md`

## 0.5.0 - 2026-02-22

### Added
- Added catalog-driven image definition model:
  - `images/catalog/images.json`
  - `scripts/catalog/images.sh`
- Added workflow documentation comments across all workflow files to improve maintainability for template users.

### Changed
- Refactored build workflow to resolve image/cloud matrix from catalog instead of hardcoded OS branches.
- Refactored promote workflow to resolve per-image var paths and metadata from catalog.
- Refactored retention workflow to resolve dynamic image scope from catalog.
- Updated docs to describe catalog-based extension path for adding image types:
  - `README.md`
  - `TEMPLATE_USAGE.md`
  - `docs/repository-structure.md`

## 0.4.3 - 2026-02-22

### Changed
- Removed stray leading `\` characters from Windows template/script files that could break parsing/execution.
- Replaced Windows Packer no-op with real `ansible` provisioner execution in `images/win2022/win2022.pkr.hcl`.
- Updated CI Terratest dependency behavior to deterministic download:
  - `go mod tidy` -> `go mod download` in workflows.
- Updated build CIS summary output to explicitly `informational` status with clearer signal fields.
- Added unique random suffixes to Azure Terratest fixture resource names to reduce collision risk in concurrent runs.
- Pinned Packer plugin versions exactly in `images/common/packer/versions.pkr.hcl`.

### Added
- AWS retention script opt-in snapshot cleanup support:
  - `--delete-snapshots` flag
  - `IMAGE_FACTORY_AWS_RETENTION_DELETE_SNAPSHOTS` env var
- Retention workflow option via repository variable:
  - `AWS_RETENTION_DELETE_SNAPSHOTS=true` to enable snapshot cleanup.

## 0.4.2 - 2026-02-22

### Changed
- Pinned Windows Ansible collections to exact versions:
  - `ansible.windows` -> `3.3.0`
  - `community.windows` -> `3.1.0`
- Pinned Packer version in build workflow:
  - `hashicorp/setup-packer` -> `1.15.0`
- Pinned Packer CLI requirement in template:
  - `images/common/packer/versions.pkr.hcl` -> `required_version = \"= 1.15.0\"`

## 0.4.1 - 2026-02-22

### Changed
- Updated Ansible Lockdown role pins to current upstream releases:
  - `ansible-lockdown.rhel9_cis` -> `2.0.3`
  - `ansible-lockdown.windows_2022_cis` -> `3.0.5`

## 0.4.0 - 2026-02-22

### Added
- Added full multi-cloud workflow set:
  - `image-build.yml`
  - `image-promote.yml`
  - `image-retention.yml`
  - `image-terratest.yml`
  - `terratest-os-examples.yml`
- Added optional in-build Terratest execution path (`run_terratest`) with artifact ID normalization.
- Added cloud helper scripts for promotion and retention under:
  - `images/common/scripts/aws/`
  - `images/common/scripts/azure/`
  - `images/common/scripts/gcp/`
- Added test suite expansion:
  - smoke and compliance scripts for Linux and Windows
  - static workflow/template validators
  - Terratest fixtures and examples for AWS, Azure, and GCP
  - SSH-based example tests for RHEL 8, RHEL 9, and Windows Server 2022
- Added `Makefile` for local test workflows.
- Added/expanded documentation, including workflow variable requirements and repository structure notes.

### Changed
- Standardized build version format to:
  - `YYYY.MM.DD.HHMM.run_number.run_attempt`
- Updated build workflow to produce evidence artifacts (`manifest.json`, `cis-report.json`, logs).
- Updated promotion workflow to use reusable cloud helper scripts.
- Improved setup and usage documentation for OIDC, runner labeling, and CIS override handling.

### Security
- Reinforced OIDC-first credential model across workflows.
- Added retention dry-run controls and documented safe defaults.

## 0.1.0 - 2026-02-21

### Added
- Initial public template scaffold for multi-cloud image builds.
- Base Packer/Ansible/CIS structure for RHEL 9 and Windows Server 2022.
