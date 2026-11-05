# FrostShell - PowerShell prompt theme. Dot-source this file from your profile.
$script:FrostLightColors = @('Red', 'Yellow', 'Cyan', 'Magenta', 'White')

function Set-FrostSessionTheme {
    $applyBackground = $null -eq $global:FrostShellOriginalColors
    if ($applyBackground) {
        $global:FrostShellOriginalColors = [pscustomobject]@{
            Background = $Host.UI.RawUI.BackgroundColor
            Foreground = $Host.UI.RawUI.ForegroundColor
            Title = $Host.UI.RawUI.WindowTitle
        }
    }

    $Host.UI.RawUI.BackgroundColor = 'DarkBlue'
    $Host.UI.RawUI.ForegroundColor = 'White'
    $Host.UI.RawUI.WindowTitle = 'FrostShell | Winter terminal'
    if ($applyBackground) { Clear-Host }

    if (Get-Command Set-PSReadLineOption -ErrorAction SilentlyContinue) {
        Set-PSReadLineOption -Colors @{
            Command = 'Yellow'
            Comment = 'DarkGray'
            Default = 'White'
            Emphasis = 'Red'
            Error = 'Red'
            Keyword = 'Yellow'
            Number = 'Red'
            Operator = 'White'
            Parameter = 'Cyan'
            String = 'Magenta'
            Type = 'Cyan'
            Variable = 'Green'
        }
    }
}

function Get-FrostContext {
    $ErrorActionPreference = 'SilentlyContinue'
    $path = (Get-Location).Path
    $displayPath = $path
    if ($displayPath.Length -gt 52) {
        $parent = Split-Path (Split-Path $path -Parent) -Leaf
        $leaf = Split-Path $path -Leaf
        $displayPath = "...\$parent\$leaf"
        if ($displayPath.Length -gt 52) {
            $displayPath = '...' + $displayPath.Substring($displayPath.Length - 49)
        }
    }
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
        Path = $displayPath
        Branch = $branch
        State = $state
        Time = Get-Date -Format 'HH:mm:ss'
    }
}

function Get-FrostGreeting {
    $hour = (Get-Date).Hour
    if ($hour -lt 12) { return 'Good morning' }
    if ($hour -lt 18) { return 'Good afternoon' }
    return 'Good evening'
}

function Write-FrostTreeFrame {
    param([int]$Frame)

    Write-Host (' ' * 12) -NoNewline
    Write-Host '+' -ForegroundColor Cyan -NoNewline
    Write-Host (' ' * 5) -NoNewline
    Write-Host '.' -ForegroundColor White -NoNewline
    Write-Host (' ' * 5) -NoNewline
    Write-Host '+' -ForegroundColor Yellow
    Write-Host (' ' * 19) -NoNewline
    Write-Host '*' -ForegroundColor Yellow
    for ($layer = 0; $layer -lt 9; $layer++) {
        $width = 1 + (2 * $layer)
        Write-Host (' ' * (18 - $layer)) -NoNewline
        for ($column = 0; $column -lt $width; $column++) {
            $light = (($column + (2 * $layer) + $Frame) % 5) -eq 0
            $garland = (($column + $layer) % 7) -eq 0
            if ($light) {
                $colorIndex = ($column + $layer + $Frame) % $script:FrostLightColors.Count
                Write-Host 'o' -ForegroundColor $script:FrostLightColors[$colorIndex] -NoNewline
            } elseif ($garland) {
                Write-Host '+' -ForegroundColor Red -NoNewline
            } else {
                Write-Host '*' -ForegroundColor Green -NoNewline
            }
        }
        Write-Host ''
    }
    Write-Host (' ' * 17) -NoNewline
    Write-Host '|||' -ForegroundColor Yellow
    Write-Host (' ' * 14) -NoNewline
    Write-Host '[R]' -ForegroundColor Red -NoNewline
    Write-Host '  [G]' -ForegroundColor Green -NoNewline
    Write-Host '  [Y]' -ForegroundColor Yellow
}

function Write-FrostTree {
    param([switch]$Animate)

    $frameCount = 1
    $startLeft = 0
    $startTop = 0
    if ($Animate -and -not [Console]::IsOutputRedirected -and
        ([Console]::CursorTop + 15) -lt [Console]::BufferHeight) {
        $frameCount = 4
        $startLeft = [Console]::CursorLeft
        $startTop = [Console]::CursorTop
    }

    for ($frame = 0; $frame -lt $frameCount; $frame++) {
        if ($frame -gt 0) {
            [Console]::SetCursorPosition($startLeft, $startTop)
        }
        Write-FrostTreeFrame -Frame $frame
        if ($frame -lt ($frameCount - 1)) {
            Start-Sleep -Milliseconds 140
        }
    }
}

function frost {
    $context = Get-FrostContext
    Write-Host ''
    Write-Host ' * FROST' -ForegroundColor Green -NoNewline
    Write-Host "  /  $(Get-FrostGreeting)" -ForegroundColor Yellow
    Write-Host 'A little winter light for your command line' -ForegroundColor Cyan
    Write-FrostTree -Animate
    Write-Host ''
    Write-Host ' LOCATION ' -ForegroundColor Cyan -NoNewline
    Write-Host $context.Path -ForegroundColor White
    if ($context.Branch) {
        Write-Host " GIT $($context.Branch)" -ForegroundColor Yellow -NoNewline
        if ($context.State -eq 'modified') {
            Write-Host '  |  CHANGES' -ForegroundColor Red
        } else {
            Write-Host '  |  CLEAN' -ForegroundColor Green
        }
    }
    Write-Host '  Type frost-help for commands' -ForegroundColor Cyan
    Write-Host ''
}

function frost-help {
    Write-Host 'FrostShell commands' -ForegroundColor Green
    Write-Host '  frost       Show the animated Christmas tree and current context'
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
    $lightColor = $script:FrostLightColors[([int](Get-Date -Format 'ss') % $script:FrostLightColors.Count)]
    Write-Host ''
    Write-Host 'o' -ForegroundColor $lightColor -NoNewline
    Write-Host ' FROST' -ForegroundColor Green -NoNewline
    Write-Host "  $($context.Time)" -ForegroundColor Cyan
    Write-Host " $($context.Path)" -ForegroundColor White -NoNewline
    if ($context.Branch) {
        Write-Host "  |  $($context.Branch)" -ForegroundColor Yellow -NoNewline
        if ($context.State -eq 'modified') {
            Write-Host '  |  CHANGES' -ForegroundColor Red -NoNewline
        } else {
            Write-Host '  |  CLEAN' -ForegroundColor Green -NoNewline
        }
    }
    Write-Host ''
    Write-Host '>' -ForegroundColor Green -NoNewline
    return ' '
}

Set-FrostSessionTheme
if (-not $global:FrostShellWelcomeShown) {
    frost
    $global:FrostShellWelcomeShown = $true
}
