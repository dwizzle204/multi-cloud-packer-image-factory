#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

actionlint_bin=""
if command -v actionlint >/dev/null 2>&1; then
  actionlint_bin="$(command -v actionlint)"
else
  command -v go >/dev/null 2>&1 || {
    echo "actionlint is not installed and Go is unavailable to install it" >&2
    exit 1
  }

  mkdir -p .bin
  GOBIN="$repo_root/.bin" go install github.com/rhysd/actionlint/cmd/actionlint@latest
  actionlint_bin="$repo_root/.bin/actionlint"
fi

"$actionlint_bin" -color

echo "Workflow semantic linting: OK"
