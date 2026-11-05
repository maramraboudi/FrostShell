# FrostShell - PowerShell prompt theme. Dot-source this file from your profile.
function frost {
    Write-Host ''
    Write-Host '       *       .        ❄' -ForegroundColor Green
    Write-Host '   .      F R O S T S H E L L      *' -ForegroundColor Green
    Write-Host "        ✦  season's greetings  ✦" -ForegroundColor Yellow
    Write-Host ''
}
function frost-help {
    Write-Host 'FrostShell commands' -ForegroundColor Green
    Write-Host '  frost       Show the Christmas banner'
    Write-Host '  frost-greet Print a seasonal greeting'
    Write-Host '  frost-help  Show this help'
}
function frost-greet {
    $greetings = @(
        'May your builds be merry and your bugs be few. 🎄',
        'Wishing you a secure and snow-bright season. ❄',
        'Have a holly, jolly command line. ✨',
        'May your commits be clean and your coffee warm. ☕'
    )
    Write-Host ($greetings | Get-Random) -ForegroundColor Yellow
}
function global:prompt {
    $path = (Get-Location).Path
    $leaf = Split-Path $path -Leaf
    if ([string]::IsNullOrWhiteSpace($leaf)) { $leaf = $path }
    $branch = ''
    $gitHint = ''
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $b = git branch --show-current 2>$null
        if ($LASTEXITCODE -eq 0 -and $b) {
            $branch = "   $b"
            $status = git status --porcelain 2>$null
            if ($status) { $gitHint = '  ● changes' } else { $gitHint = '  ✓ clean' }
        }
    }
    $clock = Get-Date -Format 'HH:mm:ss'
    Write-Host ''
    Write-Host '❄  ' -NoNewline -ForegroundColor Cyan
    Write-Host $leaf -NoNewline -ForegroundColor Green
    if ($branch) { Write-Host $branch -NoNewline -ForegroundColor Yellow }
    Write-Host ''
    Write-Host "   $clock" -NoNewline -ForegroundColor DarkGray
    if ($gitHint) { Write-Host $gitHint -NoNewline -ForegroundColor Green }
    Write-Host ''
    return '❯ '
}
frost
