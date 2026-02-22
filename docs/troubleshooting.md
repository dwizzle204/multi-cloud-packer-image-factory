# Troubleshooting

## Build failures

### Authentication/OIDC failures

- Confirm workflow includes `id-token: write`.
- Verify trust policy / federated credential subject filters match repo/workflow context.
- Verify role/service account permissions are sufficient for image operations.

### Packer validation/build failures

- Confirm required `*.auto.pkrvars.hcl` files exist and contain valid values.
- Confirm base image references are valid in target region/project/subscription.
- Re-run with verbose logging (`PACKER_LOG=1`).

### Ansible/CIS failures

- Review role versions in `requirements.yml`.
- Review OS-specific override vars in `group_vars/`.
- Start from minimal exceptions, then tighten incrementally.

## Test failures

### Terratest skipped unexpectedly

- Confirm required `TERRATEST_ENABLE_*` environment flags are set to `true`.
- Confirm required test input environment variables are set.

### Terratest runtime failures

- Verify target image IDs/names and region/zone inputs.
- Verify network path for SSH/WinRM to temporary instances.
- Check cloud quota limits for test VM sizes.

## Promotion and retention failures

### Promotion cannot find image

- Confirm `image_version`, image naming, and target cloud match build output.
- Confirm tags/labels were written on build artifacts.

### Retention deleted/kept unexpected versions

- Run retention scripts with `--dry-run` first.
- Verify channel tags/labels are consistent (`candidate` / `prod`).

## Useful evidence

- Workflow logs
- `packer-output.csv`
- build `manifest.json`
- build `cis-report.json`
- `artifact-metadata.env` and `promotion-summary.env`
