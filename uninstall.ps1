$ErrorActionPreference = 'Stop'
$profilePath = $PROFILE
if (-not (Test-Path $profilePath)) { Write-Host 'No PowerShell profile found.'; exit 0 }
$lines = Get-Content $profilePath
$filtered = $lines | Where-Object { $_ -notmatch 'FrostShell theme|FrostShell\.ps1' }
Set-Content -Path $profilePath -Value $filtered
Write-Host 'FrostShell loader removed. Existing backups were kept.' -ForegroundColor Yellow
