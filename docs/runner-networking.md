# Runner Networking

This template supports multiple runner/network models.

## Common Requirements

Build jobs often need outbound access to:
- OS package repositories or mirrors
- Ansible Galaxy (or a private mirror)
- Cloud APIs (AWS/Azure/GCP)
- Any internal repositories you use (if applicable)

## Private Networking

If your environment uses private endpoints or restricted egress:
- Ensure the runner can reach required endpoints
- Ensure DNS resolution works for private services
- Use a stable egress strategy if you must allowlist outbound IPs (e.g., NAT gateway / firewall)

## Windows Builds over WinRM

If using runner-based Ansible for Windows, the runner must be able to reach the temporary Windows build VM over WinRM.
