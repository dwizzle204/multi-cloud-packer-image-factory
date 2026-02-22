#!/usr/bin/env bash
set -euo pipefail

# Bootstrap Ansible for ansible-local provisioner usage.
# Assumes RHEL9-like base image with dnf available.

sudo dnf -y update
sudo dnf -y install python3 python3-pip git
# Packer ansible-local can vendor ansible, but installing here improves reliability for templates.
sudo pip3 install --upgrade pip
sudo pip3 install "ansible>=9,<11"

# Prepare directories
sudo mkdir -p /var/log/image_factory
sudo chmod 755 /var/log/image_factory
echo "bootstrap_done" | sudo tee /var/log/image_factory/bootstrap.txt >/dev/null
