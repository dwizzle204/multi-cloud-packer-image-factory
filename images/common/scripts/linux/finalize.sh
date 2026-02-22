#!/usr/bin/env bash
set -euo pipefail

# Finalization hook - clean temp files, package caches, etc.
sudo dnf -y clean all || true
sudo rm -rf /tmp/* || true
echo "finalize_done" | sudo tee /var/log/image_factory/finalize.txt >/dev/null
