#!/usr/bin/env bash
set -euo pipefail

# Static repository-level checks that do not require launching cloud instances.
tests/ci/validate-template.sh
tests/ci/validate-workflows.sh

# Script syntax checks.
bash -n tests/smoke/linux-smoke.sh
bash -n tests/compliance/summarize-linux.sh

echo "Local test suite: OK"
