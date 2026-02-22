# Finalization hook for Windows image builds.
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Optional: disable or restrict WinRM after Ansible configuration.
# For templates, leave a clear toggle.
if ($env:IMAGE_FACTORY_DISABLE_WINRM -eq "true") {
  Write-Host "Disabling WinRM as requested..."
  Stop-Service WinRM -ErrorAction SilentlyContinue
  Set-Service -Name WinRM -StartupType Disabled
  Get-NetFirewallRule -DisplayName "ImageFactory WinRM HTTP (5985)" -ErrorAction SilentlyContinue | Remove-NetFirewallRule -ErrorAction SilentlyContinue
}

"finalize_done" | Out-File -FilePath "C:\ProgramData\ImageFactory\finalize.txt" -Encoding ascii
