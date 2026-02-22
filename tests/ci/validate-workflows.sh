#!/usr/bin/env bash
set -euo pipefail

build_wf=".github/workflows/image-build.yml"
promote_wf=".github/workflows/image-promote.yml"
terratest_wf=".github/workflows/image-terratest.yml"
os_examples_wf=".github/workflows/terratest-os-examples.yml"

check_contains() {
  local file="$1"
  local pattern="$2"
  grep -q "$pattern" "$file" || {
    echo "Expected pattern '$pattern' in $file" >&2
    exit 1
  }
}

check_contains "$build_wf" "workflow_dispatch"
check_contains "$build_wf" "matrix"
check_contains "$build_wf" "hashicorp/setup-packer"
check_contains "$build_wf" "pip3 install \"ansible"
check_contains "$build_wf" "id-token: write"
check_contains "$build_wf" "manifest.json"
check_contains "$build_wf" "cis-report.json"

check_contains "$promote_wf" "environment: prod"
check_contains "$promote_wf" "target_channel"
check_contains "$promote_wf" "promote"

check_contains "$terratest_wf" "workflow_dispatch"
check_contains "$terratest_wf" "actions/setup-go"
check_contains "$terratest_wf" "hashicorp/setup-terraform"
check_contains "$terratest_wf" "Run Terratest"

check_contains "$os_examples_wf" "workflow_dispatch"
check_contains "$os_examples_wf" "Setup Go"
check_contains "$os_examples_wf" "Run RHEL8 example"
check_contains "$os_examples_wf" "Run Windows 2022 examples"

echo "Workflow validation: OK"
