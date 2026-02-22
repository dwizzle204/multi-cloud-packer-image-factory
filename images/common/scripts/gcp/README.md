# GCP script placeholders

Use this folder for GCP-specific helper scripts shared by workflows.

Examples:
- Label/family promotion helpers for images.
- Cross-project copy/publish helpers.
- Retention cleanup for candidate and prod sets.

Retention script supports preview mode:
- `./retention-images.sh --dry-run <project_id> <image_name_prefix> <keep_prod> <keep_candidate>`
