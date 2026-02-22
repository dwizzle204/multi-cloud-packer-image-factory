# Ansible

- Playbooks live in `playbooks/`
- CIS role configuration lives in `group_vars/`
- Third-party roles/collections are pinned in `requirements.yml`

Install dependencies locally (optional):
- `ansible-galaxy role install -r requirements.yml`
- `ansible-galaxy collection install -r requirements.yml`
