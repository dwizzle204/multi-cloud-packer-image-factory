Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

param(
  [string]$ManifestPath = "C:\ProgramData\ImageFactory\manifest.json",
  [string]$CisMarkerPath = "C:\ProgramData\ImageFactory\cis_applied.txt",
  [string]$AgentsPath = "C:\ProgramData\ImageFactory\agents.json"
)

function Assert-File([string]$Path) {
  if (!(Test-Path -Path $Path -PathType Leaf)) {
    throw "Missing required file: $Path"
  }
}

Assert-File $ManifestPath
Assert-File $CisMarkerPath
Assert-File $AgentsPath

$manifest = Get-Content -Raw -Path $ManifestPath | ConvertFrom-Json
$null = Get-Content -Raw -Path $AgentsPath | ConvertFrom-Json

$requiredKeys = @("image_name", "image_version", "git_sha", "build_date", "channel")
foreach ($key in $requiredKeys) {
  if ($null -eq $manifest.$key -or [string]::IsNullOrWhiteSpace([string]$manifest.$key)) {
    throw "Missing or empty manifest key '$key' in $ManifestPath"
  }
}

$cisText = Get-Content -Raw -Path $CisMarkerPath
if ($cisText -notmatch "CIS applied") {
  throw "CIS marker exists but does not contain expected text: $CisMarkerPath"
}

Write-Host "Windows smoke test: OK"
