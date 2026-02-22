# Security

## Identity model

This template is designed for OIDC/workload federation from GitHub Actions to cloud providers.

- No long-lived cloud access keys are required for routine operation.
- Access should be granted to workflow identities with constrained subject claims.

## Least privilege scope

Grant only what is required for:

- temporary build infrastructure
- image create/read/update actions
- metadata tagging/labeling
- optional gallery/replication operations

## Secrets handling

- Do not commit credentials in repository files.
- Avoid placing secrets in Packer var files or Ansible vars.
- Use cloud-native secret stores and fetch values at runtime when needed.

## Supply chain controls

- Pin Packer plugin constraints in `images/common/packer/versions.pkr.hcl`.
- Pin Ansible role versions in `images/common/ansible/requirements.yml`.
- Review role/plugin updates before upgrading in production.

## Operational safeguards

- Require environment approvals for promotion.
- Use dry-run for retention before enabling destructive cleanup.
- Test CIS overrides in lower environments before rollout.
