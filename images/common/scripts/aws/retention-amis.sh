#!/usr/bin/env bash
set -euo pipefail

dry_run="false"
delete_snapshots="${IMAGE_FACTORY_AWS_RETENTION_DELETE_SNAPSHOTS:-false}"
if [[ "${1:-}" == "--dry-run" ]]; then
  dry_run="true"
  shift
fi
if [[ "${1:-}" == "--delete-snapshots" ]]; then
  delete_snapshots="true"
  shift
fi

if [[ $# -ne 4 ]]; then
  echo "Usage: $0 [--dry-run] [--delete-snapshots] <aws_region> <image_name_prefix> <keep_prod> <keep_candidate>" >&2
  exit 1
fi

aws_region="$1"
image_name_prefix="$2"
keep_prod="$3"
keep_candidate="$4"

retain_channel() {
  local channel="$1"
  local keep="$2"

  mapfile -t image_ids < <(aws ec2 describe-images \
    --owners self \
    --region "$aws_region" \
    --filters \
      "Name=name,Values=${image_name_prefix}-*" \
      "Name=tag:channel,Values=$channel" \
    --query 'reverse(sort_by(Images,&CreationDate))[].ImageId' \
    --output text | tr '\t' '\n' | sed '/^$/d')

  total="${#image_ids[@]}"
  if (( total <= keep )); then
    echo "No $channel AMIs to prune (total=$total, keep=$keep)"
    return
  fi

  for ((i=keep; i<total; i++)); do
    ami_id="${image_ids[$i]}"
    if [[ "$dry_run" == "true" ]]; then
      echo "[DRY-RUN] Would deregister AMI $ami_id (channel=$channel)"
    else
      snapshot_ids=()
      if [[ "$delete_snapshots" == "true" ]]; then
        mapfile -t snapshot_ids < <(aws ec2 describe-images \
          --region "$aws_region" \
          --image-ids "$ami_id" \
          --query 'Images[0].BlockDeviceMappings[].Ebs.SnapshotId' \
          --output text | tr '\t' '\n' | sed '/^$/d')
      fi

      echo "Deregistering AMI $ami_id (channel=$channel)"
      aws ec2 deregister-image --region "$aws_region" --image-id "$ami_id"

      if [[ "$delete_snapshots" == "true" ]]; then
        for snapshot_id in "${snapshot_ids[@]}"; do
          echo "Deleting snapshot $snapshot_id for AMI $ami_id"
          aws ec2 delete-snapshot --region "$aws_region" --snapshot-id "$snapshot_id"
        done
      fi
    fi
  done
}

retain_channel "prod" "$keep_prod"
retain_channel "candidate" "$keep_candidate"
