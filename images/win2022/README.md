# Windows Server 2022 image template

This folder contains the Packer template for building a Windows Server 2022 image across AWS/Azure/GCP.

- Template: `win2022.pkr.hcl`
- Variables: `win2022.auto.pkrvars.hcl` (copy from example)

Windows CIS is applied using the Ansible Lockdown role:
- `ansible-lockdown.windows_2022_cis`
