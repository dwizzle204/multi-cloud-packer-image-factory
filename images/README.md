# Images layout

This directory contains all image build definitions and shared build assets.

- `common/`
  - Shared Packer plugin/version files.
  - Shared Ansible playbooks, group vars, and local roles.
  - Shared scripts for Linux and Windows build bootstrap/finalization.
- `rhel9/`
  - RHEL 9 multi-cloud Packer template and variables.
- `win2022/`
  - Windows Server 2022 multi-cloud Packer template and variables.

Use OS-specific `*.auto.pkrvars.hcl` files for environment values.
