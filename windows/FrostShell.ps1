# FrostShell - PowerShell prompt theme. Dot-source this file from your profile.
function Get-FrostContext {
    $ErrorActionPreference = 'SilentlyContinue'
    $path = (Get-Location).Path
    $branch = ''
    $state = ''
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $inside = git -C $path rev-parse --is-inside-work-tree 2>$null
        if ($LASTEXITCODE -eq 0 -and $inside -eq 'true') {
            $branch = git -C $path branch --show-current 2>$null
            if ($LASTEXITCODE -eq 0 -and -not $branch) {
                $commit = git -C $path rev-parse --short HEAD 2>$null
                if ($LASTEXITCODE -eq 0 -and $commit) { $branch = "detached@$commit" }
            }
            $status = git -C $path status --porcelain 2>$null
            if ($status) { $state = 'modified' } else { $state = 'clean' }
        }
    }
    [pscustomobject]@{
        Path = $path
        Branch = $branch
        State = $state
        Time = Get-Date -Format 'HH:mm'
    }
}

function Get-FrostGreeting {
    $hour = (Get-Date).Hour
    if ($hour -lt 12) { return 'Good morning' }
    if ($hour -lt 18) { return 'Good afternoon' }
    return 'Good evening'
}

function frost {
    $greeting = Get-FrostGreeting
    $context = Get-FrostContext

    Write-Host ''
    Write-Host 'FROST' -ForegroundColor Cyan -NoNewline
    Write-Host " / $greeting" -ForegroundColor Yellow
    Write-Host $context.Path -ForegroundColor Green -NoNewline
    if ($context.Branch) {
        Write-Host "  |  $($context.Branch)" -ForegroundColor Yellow -NoNewline
        Write-Host "  |  $($context.State)" -ForegroundColor DarkGray
    } else {
        Write-Host ''
    }
    Write-Host ''
}

function frost-help {
    Write-Host 'FrostShell commands' -ForegroundColor Green
    Write-Host '  frost       Show the welcome and current Git context'
    Write-Host '  frost-greet Print a seasonal greeting'
    Write-Host '  frost-help  Show this help'
}

function frost-greet {
    $greetings = @(
        'May your builds be merry and your bugs be few.',
        'Wishing you a secure and snow-bright season.',
        'Have a holly, jolly command line.',
        'May your commits be clean and your coffee warm.'
    )
    Write-Host ($greetings | Get-Random) -ForegroundColor Yellow
}

function global:prompt {
    $context = Get-FrostContext
    Write-Host ''
    Write-Host 'FROST' -ForegroundColor Cyan -NoNewline
    Write-Host "  $($context.Time)" -ForegroundColor DarkGray -NoNewline
    Write-Host "  $($context.Path)" -ForegroundColor Green -NoNewline
    if ($context.Branch) {
        Write-Host "  |  $($context.Branch)" -ForegroundColor Yellow -NoNewline
        if ($context.State -eq 'modified') {
            Write-Host '  |  modified' -ForegroundColor Red -NoNewline
        } else {
            Write-Host '  |  clean' -ForegroundColor DarkGray -NoNewline
        }
    }
    Write-Host ''
    Write-Host '>' -ForegroundColor Green -NoNewline
    return ' '
}

if (-not $global:FrostShellWelcomeShown) {
    Write-Host ''
    Write-Host 'FROST' -ForegroundColor Cyan -NoNewline
    Write-Host " / $(Get-FrostGreeting)" -ForegroundColor Yellow
    Write-Host ''
    $global:FrostShellWelcomeShown = $true
}
