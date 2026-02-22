#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 4 || $# -gt 5 ]]; then
  echo "Usage: $0 <resource_group> <image_full_name> <target_channel> <image_version> [source_channel]" >&2
  exit 1
fi

resource_group="$1"
image_full_name="$2"
target_channel="$3"
image_version="$4"
source_channel="${5:-candidate}"

image_id="$(az image show \
  --resource-group "$resource_group" \
  --name "$image_full_name" \
  --query id -o tsv)"

if [[ -z "$image_id" ]]; then
  echo "Unable to find managed image '$image_full_name' in resource group '$resource_group'" >&2
  exit 1
fi

promoted_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
az tag update \
  --resource-id "$image_id" \
  --operation Merge \
  --tags \
    channel="$target_channel" \
    image_version="$image_version" \
    promoted_from="$source_channel" \
    promoted_at="$promoted_at" >/dev/null

echo "$image_id"
