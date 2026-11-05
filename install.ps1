$ErrorActionPreference = 'Stop'
$source = Join-Path $PSScriptRoot 'windows/FrostShell.ps1'
if (-not (Test-Path $source)) { throw 'FrostShell.ps1 not found.' }
$profilePath = $PROFILE
$profileDir = Split-Path -Parent $profilePath
if (-not (Test-Path $profileDir)) { New-Item -ItemType Directory -Path $profileDir -Force | Out-Null }
if (-not (Test-Path $profilePath)) { New-Item -ItemType File -Path $profilePath -Force | Out-Null }
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
Copy-Item $profilePath "$profilePath.frostshell-backup-$stamp" -Force
$loader = ". '$source'"
$content = Get-Content $profilePath -Raw
if ($content -notlike '*FrostShell.ps1*') { Add-Content -Path $profilePath -Value "`r`n# FrostShell theme`r`n$loader" }
Write-Host 'FrostShell installed. Restart PowerShell to activate.' -ForegroundColor Green
Write-Host "Profile backup: $profilePath.frostshell-backup-$stamp"
