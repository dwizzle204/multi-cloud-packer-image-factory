# Architecture

## Core flow

```text
GitHub Actions
  -> Packer
    -> Ansible Lockdown
      -> Cloud Image Registry
```

## Detailed build flow

```text
GitHub Actions
  -> Packer builder (`amazon-ebs` / `azure-arm` / `googlecompute`)
    -> temporary build VM
      -> Ansible playbook
        -> Ansible Lockdown CIS remediation role
          -> cloud image artifact
            -> promotion metadata update (candidate -> prod)
```

## Separation of concerns

- Packer: image assembly and publication
- Ansible: OS configuration orchestration
- Ansible Lockdown: CIS-aligned remediation controls
- GitHub Actions: orchestration, identity federation, approvals, and audit trail
- Promotion: lifecycle state changes only (no rebuild)

## OS build model

- RHEL 9: Packer uses `ansible-local` on the build VM.
- Windows Server 2022: The template uses runner-based automation with WinRM during build and test phases.

If you change these patterns, keep the change documented and consistent across workflows and test stages.
