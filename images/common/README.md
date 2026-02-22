# Common image assets

Shared components used by all OS image builds:

- `packer/`: plugin/version pins and common variables/locals.
- `ansible/`: playbooks, role wiring, and hardening configuration.
- `scripts/`: build VM bootstrap/finalization hooks.

Cloud-specific account/project details should stay in OS var files under `images/rhel9/` and `images/win2022/`.
