#!/usr/bin/env bash
set -euo pipefail

manifest="${1:-/var/log/image_factory/manifest.json}"
cis_marker="${2:-/var/log/image_factory/cis_applied.txt}"
out="${3:-/var/log/image_factory/compliance_summary.json}"

[[ -f "$manifest" ]] || { echo "manifest not found: $manifest" >&2; exit 1; }
[[ -f "$cis_marker" ]] || { echo "cis marker not found: $cis_marker" >&2; exit 1; }

python3 -m json.tool "$manifest" >/dev/null

status="pass"
notes=()
for key in image_name image_version git_sha build_date channel; do
  if ! grep -q "\"$key\"" "$manifest"; then
    status="fail"
    notes+=("missing manifest key: $key")
  fi
done

if ! grep -qi "CIS applied" "$cis_marker"; then
  status="fail"
  notes+=("missing expected CIS marker text")
fi

if [[ ${#notes[@]} -eq 0 ]]; then
  notes_json='["baseline metadata and CIS marker checks passed"]'
else
  joined=""
  for n in "${notes[@]}"; do
    [[ -n "$joined" ]] && joined+=", "
    joined+="\"$n\""
  done
  notes_json="[$joined]"
fi

cat > "$out" <<JSON
{
  "status": "$status",
  "manifest_path": "$manifest",
  "cis_marker_path": "$cis_marker",
  "notes": $notes_json
}
JSON

echo "Wrote $out"
