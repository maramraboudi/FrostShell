$ErrorActionPreference = 'Stop'
$source = Join-Path $PSScriptRoot 'windows/FrostShell.ps1'
if (-not (Test-Path $source)) { throw 'FrostShell.ps1 not found.' }
$profilePath = $PROFILE
$profileDir = Split-Path -Parent $profilePath
if (-not (Test-Path $profileDir)) { New-Item -ItemType Directory -Path $profileDir -Force | Out-Null }
if (-not (Test-Path $profilePath)) { New-Item -ItemType File -Path $profilePath -Force | Out-Null }
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
Copy-Item $profilePath "$profilePath.frostshell-backup-$stamp" -Force
$escapedSource = $source.Replace("'", "''")
$loader = ". '$escapedSource'"
$content = Get-Content $profilePath -Raw
$loaderPattern = '(?m)^' + [regex]::Escape($loader) + '\s*$'
if ($content -notmatch $loaderPattern) {
    $append = "`r`n"
    if ($content -notmatch '(?m)^\s*# FrostShell theme\s*$') { $append += "# FrostShell theme`r`n" }
    Add-Content -Path $profilePath -Value ($append + $loader)
}
Write-Host 'FrostShell installed. Restart PowerShell to activate.' -ForegroundColor Green
Write-Host "Profile backup: $profilePath.frostshell-backup-$stamp"
