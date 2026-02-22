#!/usr/bin/env bash
set -euo pipefail

dry_run="false"
if [[ "${1:-}" == "--dry-run" ]]; then
  dry_run="true"
  shift
fi

if [[ $# -ne 4 ]]; then
  echo "Usage: $0 [--dry-run] <project_id> <image_name_prefix> <keep_prod> <keep_candidate>" >&2
  exit 1
fi

project_id="$1"
image_name_prefix="$2"
keep_prod="$3"
keep_candidate="$4"

retain_channel() {
  local channel="$1"
  local keep="$2"

  mapfile -t image_names < <(gcloud compute images list \
    --project "$project_id" \
    --filter="name~'^${image_name_prefix}-' AND labels.channel=$channel" \
    --sort-by="~creationTimestamp" \
    --format="value(name)")

  total="${#image_names[@]}"
  if (( total <= keep )); then
    echo "No $channel images to prune (total=$total, keep=$keep)"
    return
  fi

  for ((i=keep; i<total; i++)); do
    image_name="${image_names[$i]}"
    if [[ "$dry_run" == "true" ]]; then
      echo "[DRY-RUN] Would delete image $image_name (channel=$channel)"
    else
      echo "Deleting image $image_name (channel=$channel)"
      gcloud compute images delete "$image_name" --project "$project_id" --quiet
    fi
  done
}

retain_channel "prod" "$keep_prod"
retain_channel "candidate" "$keep_candidate"
