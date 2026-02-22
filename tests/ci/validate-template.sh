#!/usr/bin/env bash
set -euo pipefail

required_files=(
  "README.md"
  "TEMPLATE_USAGE.md"
  "SETUP_GUIDE.md"
  "CHANGELOG.md"
  "VERSION"
  "docs/architecture.md"
  "docs/cis.md"
  "docs/promotion-model.md"
  "docs/security.md"
  "docs/runner-networking.md"
  "docs/troubleshooting.md"
  "images/rhel9/rhel9.pkr.hcl"
  "images/win2022/win2022.pkr.hcl"
  "images/common/ansible/requirements.yml"
  ".github/workflows/image-build.yml"
  ".github/workflows/reusable-image-build.yml"
  ".github/workflows/image-promote.yml"
  ".github/workflows/image-terratest.yml"
  ".github/workflows/terratest-os-examples.yml"
  "tests/ci/lint-workflows.sh"
  "images/catalog/images.json"
  "scripts/catalog/images.sh"
  "Makefile"
)

for f in "${required_files[@]}"; do
  [[ -f "$f" ]] || { echo "Missing required file: $f" >&2; exit 1; }
done

for d in docs images tests .github/workflows; do
  [[ -d "$d" ]] || { echo "Missing required directory: $d" >&2; exit 1; }
done

echo "Template structure validation: OK"
