# Repository structure

## Top-level layout

- `.github/workflows/`
- `images/`
- `docs/`
- `tests/`
- `README.md`
- `TEMPLATE_USAGE.md`
- `SETUP_GUIDE.md`
- `CHANGELOG.md`
- `VERSION`

## Workflow files

- `image-build.yml`: build and validation artifacts
- `image-terratest.yml`: cloud fixture Terratest execution
- `terratest-os-examples.yml`: SSH-based RHEL/Windows example tests
- `image-promote.yml`: channel promotion (metadata only)
- `image-retention.yml`: lifecycle cleanup by policy

## Image content layout

- `images/common/`
  - shared Packer config, Ansible content, helper scripts
- `images/rhel9/`
  - RHEL 9 Packer templates and vars
- `images/win2022/`
  - Windows Server 2022 Packer templates and vars

## Required local runtime files

Create from examples before local runs:

- `images/rhel9/rhel9.auto.pkrvars.hcl`
- `images/win2022/win2022.auto.pkrvars.hcl`
