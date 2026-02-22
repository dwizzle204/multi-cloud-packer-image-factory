#!/usr/bin/env bash
set -euo pipefail

catalog_file="${IMAGE_CATALOG_FILE:-images/catalog/images.json}"

usage() {
  cat <<USAGE
Usage:
  scripts/catalog/images.sh list
  scripts/catalog/images.sh select <all|image_key|image_key1,image_key2>
  scripts/catalog/images.sh matrix <all|image_key|image_key1,image_key2> <cloud1,cloud2,...>
  scripts/catalog/images.sh get <image_key> <field>
  scripts/catalog/images.sh builder <image_key> <cloud>
  scripts/catalog/images.sh template-files <image_key>
USAGE
}

require_tools() {
  command -v jq >/dev/null 2>&1 || {
    echo "jq is required but not installed" >&2
    exit 1
  }
}

trim() {
  local x="$1"
  x="${x#"${x%%[![:space:]]*}"}"
  x="${x%"${x##*[![:space:]]}"}"
  printf '%s' "$x"
}

ensure_catalog() {
  [[ -f "$catalog_file" ]] || {
    echo "Catalog file not found: $catalog_file" >&2
    exit 1
  }
}

validate_image_key() {
  local key="$1"
  jq -e --arg k "$key" '.images[$k] != null' "$catalog_file" >/dev/null || {
    echo "Unknown image key: $key" >&2
    exit 1
  }
}

validate_cloud_name() {
  local cloud="$1"
  case "$cloud" in
    aws|azure|gcp) ;;
    *)
      echo "Invalid cloud '$cloud'. Allowed: aws, azure, gcp" >&2
      exit 1
      ;;
  esac
}

resolve_images_json() {
  local selector="$1"

  if [[ "$selector" == "all" ]]; then
    jq -c '.images | keys' "$catalog_file"
    return 0
  fi

  local out='[]'
  local item
  IFS=',' read -ra items <<< "$selector"
  for item in "${items[@]}"; do
    item="$(trim "$item")"
    [[ -n "$item" ]] || continue
    validate_image_key "$item"
    out="$(jq -c --arg item "$item" '. + [$item]' <<<"$out")"
  done

  [[ "$out" != "[]" ]] || {
    echo "No valid image keys were provided" >&2
    exit 1
  }

  jq -c 'unique' <<<"$out"
}

resolve_clouds_json() {
  local clouds_csv="$1"
  local out='[]'
  local c
  IFS=',' read -ra clouds <<< "$clouds_csv"
  for c in "${clouds[@]}"; do
    c="$(trim "$c")"
    [[ -n "$c" ]] || continue
    validate_cloud_name "$c"
    out="$(jq -c --arg cloud "$c" '. + [$cloud]' <<<"$out")"
  done

  [[ "$out" != "[]" ]] || {
    echo "At least one cloud must be provided" >&2
    exit 1
  }

  jq -c 'unique' <<<"$out"
}

cmd_list() {
  jq -r '.images | keys[]' "$catalog_file"
}

cmd_select() {
  local selector="$1"
  resolve_images_json "$selector"
}

cmd_matrix() {
  local selector="$1"
  local clouds_csv="$2"

  local images_json
  local clouds_json
  images_json="$(resolve_images_json "$selector")"
  clouds_json="$(resolve_clouds_json "$clouds_csv")"

  jq -cn --argjson images "$images_json" --argjson clouds "$clouds_json" --argfile catalog "$catalog_file" '
    [
      $images[] as $img
      | $clouds[] as $cloud
      | select($catalog.images[$img].builders[$cloud] != null)
      | {
          image_key: $img,
          cloud: $cloud
        }
    ]
  '
}

cmd_get() {
  local image_key="$1"
  local field="$2"
  validate_image_key "$image_key"
  jq -er --arg image "$image_key" --arg field "$field" '.images[$image][$field]' "$catalog_file"
}

cmd_builder() {
  local image_key="$1"
  local cloud="$2"
  validate_image_key "$image_key"
  validate_cloud_name "$cloud"
  jq -er --arg image "$image_key" --arg cloud "$cloud" '.images[$image].builders[$cloud]' "$catalog_file"
}

cmd_template_files() {
  local image_key="$1"
  validate_image_key "$image_key"
  jq -er --arg image "$image_key" '.images[$image].template_files[]' "$catalog_file"
}

main() {
  require_tools
  ensure_catalog

  local cmd="${1:-}"
  case "$cmd" in
    list)
      cmd_list
      ;;
    select)
      [[ $# -eq 2 ]] || { usage >&2; exit 1; }
      cmd_select "$2"
      ;;
    matrix)
      [[ $# -eq 3 ]] || { usage >&2; exit 1; }
      cmd_matrix "$2" "$3"
      ;;
    get)
      [[ $# -eq 3 ]] || { usage >&2; exit 1; }
      cmd_get "$2" "$3"
      ;;
    builder)
      [[ $# -eq 3 ]] || { usage >&2; exit 1; }
      cmd_builder "$2" "$3"
      ;;
    template-files)
      [[ $# -eq 2 ]] || { usage >&2; exit 1; }
      cmd_template_files "$2"
      ;;
    *)
      usage >&2
      exit 1
      ;;
  esac
}

main "$@"
