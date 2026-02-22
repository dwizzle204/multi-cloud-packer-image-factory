# Terratest examples

This directory contains example Terratest coverage that spins up lightweight test instances from built images in AWS, Azure, and GCP.

These tests are intentionally environment-gated and skip unless enabled.

## Run locally

```bash
cd tests/terratest
go test -v ./...
```

Recommended Go version: `>= 1.22`.

## AWS example env vars

- `TERRATEST_ENABLE_AWS=true`
- `AWS_TEST_REGION`
- `AWS_TEST_IMAGE_ID`
- Optional: `AWS_TEST_INSTANCE_TYPE`, `AWS_TEST_SUBNET_ID`, `AWS_TEST_SECURITY_GROUP_ID`

## Azure example env vars

- `TERRATEST_ENABLE_AZURE=true`
- `AZURE_TEST_IMAGE_ID`
- `AZURE_TEST_RESOURCE_GROUP`
- `AZURE_TEST_SUBNET_ID`
- `AZURE_TEST_LOCATION`
- Optional: `TEST_OS_TYPE` (`linux` or `windows`), `AZURE_TEST_VM_SIZE`, `AZURE_TEST_ADMIN_USERNAME`, `AZURE_TEST_LINUX_SSH_PUBLIC_KEY`, `AZURE_TEST_WINDOWS_ADMIN_PASSWORD`

## GCP example env vars

- `TERRATEST_ENABLE_GCP=true`
- `GCP_TEST_PROJECT_ID`
- `GCP_TEST_ZONE`
- `GCP_TEST_IMAGE_NAME`
- Optional: `GCP_TEST_MACHINE_TYPE`, `GCP_TEST_NETWORK`

## Notes

- These are example acceptance-style tests, not exhaustive production tests.
- Instances are created by Terraform and destroyed with `defer terraform.Destroy(...)`.
- Use dedicated test subscriptions/accounts/projects with strict cost controls.
- `tests/terratest/scripts/normalize-packer-artifact-id.sh` converts Packer artifact IDs into cloud-specific Terratest inputs.

## Additional OS-focused examples

RHEL 8/9 SSH-based checks:

- `TestExampleRHEL8SmokeOverSSH`
- `TestExampleRHEL9SmokeOverSSH`

Enable with:

- `TERRATEST_ENABLE_RHEL_EXAMPLES=true`
- `TERRATEST_RHEL_TARGET_VERSION=8` or `9`
- `TERRATEST_RHEL_HOST`
- `TERRATEST_RHEL_SSH_USER`
- `TERRATEST_RHEL_SSH_PRIVATE_KEY_PATH`
- Optional: `TERRATEST_RHEL_SSH_PORT`

Windows Server 2022 SSH-based checks:

- `TestExampleWindows2022SmokeOverSSH`
- `TestExampleWindows2022WinRMService`

Enable with:

- `TERRATEST_ENABLE_WINDOWS_EXAMPLES=true`
- `TERRATEST_WINDOWS_HOST`
- `TERRATEST_WINDOWS_SSH_USER`
- `TERRATEST_WINDOWS_SSH_PRIVATE_KEY_PATH`
- Optional: `TERRATEST_WINDOWS_SSH_PORT`
