# Setup Guide (Public Template)

This guide describes the minimum setup to run image builds securely with OIDC federation and no long-lived cloud credentials.

Follow sections in order from GitHub configuration through cloud federation and CIS role preparation.

## Prerequisites

- GitHub repository created from this template
- Cloud access to create identity federation resources
- Permission to assign least-privilege roles/policies in AWS, Azure, and GCP

## A) GitHub Setup

### 1. Enable Actions and OIDC permissions

Ensure workflows run with:

- `permissions: id-token: write`
- `permissions: contents: read`

### 2. Configure protected promotion environment

Create environment `prod` and require reviewers as needed by your policy.

### 3. Configure runner model

Choose one:

- GitHub-hosted
- Larger GitHub-hosted
- Self-hosted

If self-hosted, define labels and map jobs consistently (for example `image-build-linux`, `image-build-windows`, `image-promote`).

### 4. Configure workflow variables/secrets

Set values listed in `docs/workflow-variables.md`.

## B) Azure Setup

1. Create an Entra application/service principal for workload identity federation.
2. Create federated credentials that trust your GitHub repository/workflow identity.
3. Assign least-privilege RBAC for image build, tagging, and optional gallery operations.
4. (Recommended) create an Azure Compute Gallery for distribution and version lifecycle.

## C) AWS Setup

1. Create or reuse GitHub OIDC identity provider.
2. Create IAM role with trust policy for your repo/workflow subject claims.
3. Attach least-privilege policies for temporary build resources, AMI creation, snapshot handling, and tagging.

## D) GCP Setup

1. Create Workload Identity Pool + Provider for GitHub OIDC.
2. Create service account for image build operations.
3. Bind workload identity principal to service account.
4. Grant least-privilege roles for compute image create/read/label operations.

## E) Ansible Lockdown Setup

1. Review and pin role versions in `images/common/ansible/requirements.yml`.
2. Define CIS overrides in:
   - `images/common/ansible/group_vars/rhel9.yml`
   - `images/common/ansible/group_vars/win2022.yml`
3. Test hardening behavior in non-production accounts/subscriptions/projects before broader rollout.

## Configure image variables

Create runtime var files from examples:

- `images/rhel9/rhel9.auto.pkrvars.hcl`
- `images/win2022/win2022.auto.pkrvars.hcl`

Set cloud identifiers, base images, regions, VM sizes, and naming.

## Run workflows

1. **Image Build**
   Recommended first run: `os=rhel9`, one cloud, `channel=candidate`

2. **Image Terratest** (optional)
   Validate image boot/runtime behavior with ephemeral test instances

3. **Image Promote**
   Promote known-good versions to `prod` via metadata tags/labels

4. **Image Retention**
   Enforce candidate/prod retention policy (use dry-run first)

## Operational notes

- Promotion should never rebuild images.
- CIS remediation can impact functionality; test before broad rollout.
- Keep exceptions explicit, minimal, and documented.
