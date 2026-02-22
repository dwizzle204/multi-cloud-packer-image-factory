#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 4 || $# -gt 5 ]]; then
  echo "Usage: $0 <aws_region> <image_full_name> <image_version> <target_channel> [source_channel]" >&2
  exit 1
fi

aws_region="$1"
image_full_name="$2"
image_version="$3"
target_channel="$4"
source_channel="${5:-candidate}"

ami_id="$(aws ec2 describe-images \
  --owners self \
  --region "$aws_region" \
  --filters \
    "Name=name,Values=$image_full_name" \
    "Name=tag:image_version,Values=$image_version" \
  --query 'Images | sort_by(@,&CreationDate)[-1].ImageId' \
  --output text)"

if [[ -z "$ami_id" || "$ami_id" == "None" ]]; then
  echo "Unable to find AMI name=$image_full_name image_version=$image_version in region=$aws_region" >&2
  exit 1
fi

promoted_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
aws ec2 create-tags \
  --region "$aws_region" \
  --resources "$ami_id" \
  --tags \
    "Key=channel,Value=$target_channel" \
    "Key=promoted_from,Value=$source_channel" \
    "Key=promoted_at,Value=$promoted_at"

echo "$ami_id"
