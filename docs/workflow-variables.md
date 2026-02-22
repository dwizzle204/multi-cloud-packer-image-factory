# Workflow variables

This document lists GitHub repository variables and secrets expected by workflows.

## Core OIDC Variables (Required)

- `AWS_ROLE_TO_ASSUME`
- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`
- `GCP_WORKLOAD_IDENTITY_PROVIDER`
- `GCP_SERVICE_ACCOUNT`

## Build Workflow (`image-build.yml`)

Optional variables:

- `RUN_TERRATEST_ON_SCHEDULE` (`true|false`, default `false`)
- `PUBLISH_CIS_SARIF_ON_SCHEDULE` (`true|false`, default `true`)
- `PACKER_LOG` (`1` enables verbose Packer logs)
- `PACKER_LOG_PATH` (path for Packer log output)

Manual workflow inputs can override schedule defaults:

- `run_terratest`
- `publish_cis_sarif`

The build workflow always publishes a human-readable summary to the GitHub Actions run summary (`$GITHUB_STEP_SUMMARY`), regardless of SARIF upload setting.
The generated `cis-report.json` is an informational signal artifact by default, not an authoritative compliance attestation.

Toolchain pin:

- Packer is installed as `1.15.0` in `image-build.yml` (no `latest` usage).

## Retention Workflow (`image-retention.yml`)

Optional policy defaults:

- `KEEP_PROD_IMAGES` (default `5`)
- `KEEP_CANDIDATE_IMAGES` (default `10`)
- `RETENTION_DRY_RUN` (`true|false`, default `false`)
- `AWS_RETENTION_DELETE_SNAPSHOTS` (`true|false`, default `false`)
  - When `true`, AWS retention also deletes snapshots associated with deregistered AMIs.

## Terratest Cloud Workflow (`image-terratest.yml`)

Repository variables:

- `AZURE_TEST_RESOURCE_GROUP`
- `AZURE_TEST_SUBNET_ID`
- `AZURE_TEST_LOCATION`
- `AZURE_TEST_ADMIN_USERNAME`
- `AZURE_TEST_LINUX_SSH_PUBLIC_KEY`
- `GCP_TEST_PROJECT_ID`
- `GCP_TEST_ZONE`

Repository secrets:

- `AZURE_TEST_WINDOWS_ADMIN_PASSWORD` (required only for Windows Azure test path)

## Terratest OS Example Workflow (`terratest-os-examples.yml`)

Repository variables:

- `TERRATEST_RHEL8_HOST`
- `TERRATEST_RHEL9_HOST`
- `TERRATEST_RHEL_SSH_USER`
- `TERRATEST_RHEL_SSH_PORT` (optional)
- `TERRATEST_WINDOWS2022_HOST`
- `TERRATEST_WINDOWS_SSH_USER`
- `TERRATEST_WINDOWS_SSH_PORT` (optional)

Repository secrets:

- `TERRATEST_RHEL_SSH_PRIVATE_KEY`
- `TERRATEST_WINDOWS_SSH_PRIVATE_KEY`

## Required Runtime Var Files in Repo

These files must exist for build/promote/retention workflows:

- `images/rhel9/rhel9.auto.pkrvars.hcl`
- `images/win2022/win2022.auto.pkrvars.hcl`

Optional cloud override files (auto-applied when present):

- `images/rhel9/overrides/aws.pkrvars.hcl`
- `images/rhel9/overrides/azure.pkrvars.hcl`
- `images/rhel9/overrides/gcp.pkrvars.hcl`
- `images/win2022/overrides/aws.pkrvars.hcl`
- `images/win2022/overrides/azure.pkrvars.hcl`
- `images/win2022/overrides/gcp.pkrvars.hcl`

## Versioning

Automatic build version format:

- `YYYY.MM.DD.HHMM.run_number.run_attempt`
- Example: `2026.02.22.0320.184.1`

## Security Guidance

Use OIDC federation and short-lived credentials. Do not store long-lived cloud keys in GitHub secrets for routine operation.
