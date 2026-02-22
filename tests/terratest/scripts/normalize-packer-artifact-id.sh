#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 || $# -gt 4 ]]; then
  echo "Usage: $0 <cloud> <artifact_id> [default_aws_region] [default_gcp_project_id]" >&2
  exit 1
fi

cloud="$1"
artifact_id="$2"
default_aws_region="${3:-}"
default_gcp_project_id="${4:-}"

emit() {
  local k="$1"
  local v="$2"
  echo "${k}=${v}"
}

case "$cloud" in
  aws)
    ami_id="$(echo "$artifact_id" | grep -oE 'ami-[a-zA-Z0-9]+' | head -n1 || true)"
    [[ -n "$ami_id" ]] || { echo "Could not parse AWS AMI id from artifact_id: $artifact_id" >&2; exit 1; }

    aws_region="$default_aws_region"
    if [[ "$artifact_id" =~ ^([a-z0-9-]+):ami-[a-zA-Z0-9]+$ ]]; then
      aws_region="${BASH_REMATCH[1]}"
    fi
    [[ -n "$aws_region" ]] || { echo "AWS region missing (artifact_id/default_aws_region)" >&2; exit 1; }

    emit "terratest_image_id" "$ami_id"
    emit "terratest_aws_region" "$aws_region"
    ;;

  azure)
    # Azure packer artifact IDs are typically full resource IDs.
    emit "terratest_image_id" "$artifact_id"
    ;;

  gcp)
    gcp_project="$default_gcp_project_id"
    gcp_image="$artifact_id"

    if [[ "$artifact_id" =~ ^projects/([^/]+)/global/images/([^/]+)$ ]]; then
      gcp_project="${BASH_REMATCH[1]}"
      gcp_image="${BASH_REMATCH[2]}"
    elif [[ "$artifact_id" =~ ^([^:]+):([^:]+)$ ]]; then
      gcp_project="${BASH_REMATCH[1]}"
      gcp_image="${BASH_REMATCH[2]}"
    fi

    [[ -n "$gcp_project" ]] || { echo "GCP project missing (artifact_id/default_gcp_project_id)" >&2; exit 1; }
    [[ -n "$gcp_image" ]] || { echo "GCP image name missing" >&2; exit 1; }

    emit "terratest_image_id" "$gcp_image"
    emit "terratest_gcp_project_id" "$gcp_project"
    ;;

  *)
    echo "Unsupported cloud: $cloud" >&2
    exit 1
    ;;
esac
