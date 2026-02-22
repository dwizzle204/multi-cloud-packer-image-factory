#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 4 || $# -gt 5 ]]; then
  echo "Usage: $0 <project_id> <image_full_name> <target_channel> <image_version> [source_channel]" >&2
  exit 1
fi

project_id="$1"
image_full_name="$2"
target_channel="$3"
image_version="$4"
source_channel="${5:-candidate}"
promoted_at="$(date -u +%Y%m%d%H%M%S)"

gcloud compute images add-labels "$image_full_name" \
  --project "$project_id" \
  --labels "channel=$target_channel,image_version=${image_version//./-},promoted_from=$source_channel,promoted_at=$promoted_at" \
  --quiet

echo "projects/$project_id/global/images/$image_full_name"
