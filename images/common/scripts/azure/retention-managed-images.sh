#!/usr/bin/env bash
set -euo pipefail

dry_run="false"
if [[ "${1:-}" == "--dry-run" ]]; then
  dry_run="true"
  shift
fi

if [[ $# -ne 4 ]]; then
  echo "Usage: $0 [--dry-run] <resource_group> <image_name_prefix> <keep_prod> <keep_candidate>" >&2
  exit 1
fi

resource_group="$1"
image_name_prefix="$2"
keep_prod="$3"
keep_candidate="$4"

retain_channel() {
  local channel="$1"
  local keep="$2"

  mapfile -t image_names < <(az image list \
    --resource-group "$resource_group" \
    --query "reverse(sort_by([?starts_with(name, '${image_name_prefix}-') && tags.channel=='${channel}'], &timeCreated))[].name" \
    -o tsv)

  total="${#image_names[@]}"
  if (( total <= keep )); then
    echo "No $channel managed images to prune (total=$total, keep=$keep)"
    return
  fi

  for ((i=keep; i<total; i++)); do
    image_name="${image_names[$i]}"
    if [[ "$dry_run" == "true" ]]; then
      echo "[DRY-RUN] Would delete managed image $image_name (channel=$channel)"
    else
      echo "Deleting managed image $image_name (channel=$channel)"
      az image delete --resource-group "$resource_group" --name "$image_name"
    fi
  done
}

retain_channel "prod" "$keep_prod"
retain_channel "candidate" "$keep_candidate"
