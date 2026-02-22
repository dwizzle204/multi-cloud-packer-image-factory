#!/usr/bin/env bash
set -euo pipefail

manifest_path="${1:-/var/log/image_factory/manifest.json}"
cis_marker_path="${2:-/var/log/image_factory/cis_applied.txt}"
agents_path="${3:-/var/log/image_factory/agents.json}"

require_file() {
  local path="$1"
  [[ -f "$path" ]] || { echo "Missing required file: $path" >&2; exit 1; }
}

require_manifest_key() {
  local key="$1"
  local path="$2"
  grep -q "\"$key\"" "$path" || {
    echo "Missing manifest key '$key' in $path" >&2
    exit 1
  }
}

require_file "$cis_marker_path"
require_file "$manifest_path"
require_file "$agents_path"

# Validate JSON structure and required metadata keys.
python3 -m json.tool "$manifest_path" >/dev/null
python3 -m json.tool "$agents_path" >/dev/null

require_manifest_key "image_name" "$manifest_path"
require_manifest_key "image_version" "$manifest_path"
require_manifest_key "git_sha" "$manifest_path"
require_manifest_key "build_date" "$manifest_path"
require_manifest_key "channel" "$manifest_path"

if ! grep -qi "CIS applied" "$cis_marker_path"; then
  echo "CIS marker exists but does not contain expected text: $cis_marker_path" >&2
  exit 1
fi

echo "Linux smoke test: OK"
