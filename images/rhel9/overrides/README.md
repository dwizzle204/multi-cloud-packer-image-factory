# RHEL9 cloud overrides

Optional pattern: keep cloud-specific values separate and compose them in CI.

Suggested usage:
- `rhel9.auto.pkrvars.hcl`: shared defaults for all clouds.
- `overrides/aws.pkrvars.hcl.example`: AWS-specific overrides.
- `overrides/azure.pkrvars.hcl.example`: Azure-specific overrides.
- `overrides/gcp.pkrvars.hcl.example`: GCP-specific overrides.

In a custom workflow, pass multiple var files:

`packer build -var-file=rhel9.auto.pkrvars.hcl -var-file=overrides/aws.pkrvars.hcl ...`
