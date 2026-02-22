# Azure script placeholders

Use this folder for Azure-specific helper scripts shared by workflows.

Examples:
- Promote managed images or Compute Gallery versions.
- Replicate gallery versions across regions.
- Retention cleanup by channel and age.

Retention script supports preview mode:
- `./retention-managed-images.sh --dry-run <resource_group> <image_name_prefix> <keep_prod> <keep_candidate>`
