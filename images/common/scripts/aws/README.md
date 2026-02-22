# AWS script placeholders

Use this folder for AWS-specific helper scripts that are shared across workflows.

Examples:
- Resolve AMI by version/channel.
- Copy/share AMIs across accounts/regions.
- Retention cleanup for old candidates.

Retention script supports preview mode:
- `./retention-amis.sh --dry-run <region> <image_name_prefix> <keep_prod> <keep_candidate>`

Optional snapshot cleanup:
- `./retention-amis.sh --delete-snapshots <region> <image_name_prefix> <keep_prod> <keep_candidate>`
- Or set `IMAGE_FACTORY_AWS_RETENTION_DELETE_SNAPSHOTS=true`.
