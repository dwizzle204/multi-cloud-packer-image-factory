# Bootstrap WinRM for Ansible runner-based configuration.
# NOTE: This is a starter configuration for templates. Review and harden for your environment.

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Enable WinRM
Enable-PSRemoting -Force

# Configure WinRM service
Set-Service -Name WinRM -StartupType Automatic
Start-Service WinRM

# Allow basic auth over HTTPS is NOT configured here.
# For templates, the common approach is:
# - Use temporary local admin credentials (Packer communicator) and WinRM over HTTP on private networks
# - Restrict inbound to the build network only
# You must harden this for production pipelines.

# Open firewall for WinRM HTTP (5985). Keep network scope narrow in production.
$winRmRuleName = "ImageFactory WinRM HTTP (5985)"
$remoteAddress = if ($env:IMAGE_FACTORY_WINRM_REMOTE_ADDRESS) { $env:IMAGE_FACTORY_WINRM_REMOTE_ADDRESS } else { "*" }

Get-NetFirewallRule -DisplayName $winRmRuleName -ErrorAction SilentlyContinue | Remove-NetFirewallRule -ErrorAction SilentlyContinue
New-NetFirewallRule `
  -DisplayName $winRmRuleName `
  -Direction Inbound `
  -Action Allow `
  -Protocol TCP `
  -LocalPort 5985 `
  -RemoteAddress $remoteAddress `
  -Profile Any `
  -ErrorAction SilentlyContinue | Out-Null

New-Item -ItemType Directory -Force -Path "C:\ProgramData\ImageFactory" | Out-Null
"bootstrap_done" | Out-File -FilePath "C:\ProgramData\ImageFactory\bootstrap.txt" -Encoding ascii
