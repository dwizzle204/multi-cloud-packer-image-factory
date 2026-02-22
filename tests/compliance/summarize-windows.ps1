Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

param(
  [string]$ManifestPath = "C:\ProgramData\ImageFactory\manifest.json",
  [string]$CisMarkerPath = "C:\ProgramData\ImageFactory\cis_applied.txt",
  [string]$OutPath = "C:\ProgramData\ImageFactory\compliance_summary.json"
)

if (!(Test-Path $ManifestPath)) { throw "Manifest not found: $ManifestPath" }
if (!(Test-Path $CisMarkerPath)) { throw "CIS marker not found: $CisMarkerPath" }

$manifest = Get-Content -Raw -Path $ManifestPath | ConvertFrom-Json
$cisText = Get-Content -Raw -Path $CisMarkerPath

$status = "pass"
$notes = New-Object System.Collections.Generic.List[string]
$requiredKeys = @("image_name", "image_version", "git_sha", "build_date", "channel")
foreach ($key in $requiredKeys) {
  if ($null -eq $manifest.$key -or [string]::IsNullOrWhiteSpace([string]$manifest.$key)) {
    $status = "fail"
    $notes.Add("missing manifest key: $key")
  }
}

if ($cisText -notmatch "CIS applied") {
  $status = "fail"
  $notes.Add("missing expected CIS marker text")
}

if ($notes.Count -eq 0) {
  $notes.Add("baseline metadata and CIS marker checks passed")
}

$result = [ordered]@{
  status = $status
  manifest_path = $ManifestPath
  cis_marker_path = $CisMarkerPath
  notes = $notes
}

$result | ConvertTo-Json -Depth 4 | Out-File -FilePath $OutPath -Encoding utf8
Write-Host "Wrote $OutPath"
