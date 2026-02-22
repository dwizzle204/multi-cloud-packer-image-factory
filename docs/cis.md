# CIS Hardening (Ansible Lockdown)

This template applies CIS hardening using Ansible Lockdown roles:

- RHEL 9: `ansible-lockdown.rhel9_cis`
- Windows Server 2022: `ansible-lockdown.windows_2022_cis`

This repository does not include CIS benchmark content text.

## Targeted CIS level

- This template is designed to start from a CIS Level 1-style baseline.
- Organizations can tighten selected controls toward stricter profiles after validation.

## Important Notes

- These roles are **remediation** roles (they change system configuration).
- Do not rely on Ansible check-mode to validate Windows remediation runs.
- CIS is not “one size fits all”. Review control impact before broad rollout.
- Test CIS remediation in controlled environments before broad rollout.

## Where to Configure Overrides and Exceptions

Use group vars:

- `images/common/ansible/group_vars/rhel9.yml`
- `images/common/ansible/group_vars/win2022.yml`

Keep exceptions explicit, and document why they exist.

## Reporting

This template:
- writes a "CIS applied" marker file
- writes a build manifest JSON file
- provides placeholder scripts under `tests/compliance/` to parse logs into a summary artifact

Enhancements you can add:
- OpenSCAP scan for Linux
- Additional compliance tooling per your needs
