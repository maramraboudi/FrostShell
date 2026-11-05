# FrostShell - festive PowerShell scene and prompt.
param(
    [ValidateSet('Welcome', 'Tree', 'Greet', 'Help')]
    [string]$Action = 'Welcome'
)

$script:FrostLightColors = @('Red', 'Yellow', 'Cyan', 'Magenta', 'White')

function Get-FrostContext {
    $ErrorActionPreference = 'SilentlyContinue'
    $path = (Get-Location).Path
    $displayPath = $path
    if ($displayPath.Length -gt 48) {
        $parent = Split-Path (Split-Path $path -Parent) -Leaf
        $leaf = Split-Path $path -Leaf
        $displayPath = "...\$parent\$leaf"
        if ($displayPath.Length -gt 48) {
            $displayPath = '...' + $displayPath.Substring($displayPath.Length - 45)
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
            if ($status) { $state = 'changes' } else { $state = 'clean' }
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

function Write-FrostSky {
    param([int]$Frame, [int]$Layer, [int]$TreeHeight)

    $width = 78
    $line = New-Object char[] $width
    $colors = New-Object object[] $width
    for ($column = 0; $column -lt $width; $column++) {
        $line[$column] = ' '
        $colors[$column] = 'DarkGray'
    }

    $treeLayer = $Layer
    $treeStart = 2 + ($TreeHeight - 1 - $treeLayer)
    if ($treeLayer -eq 0) {
        $line[($treeStart + 0)] = '*'
        $colors[($treeStart + 0)] = 'Yellow'
    } elseif ($treeLayer -lt $TreeHeight) {
        $treeWidth = 1 + (2 * $treeLayer)
        for ($branch = 0; $branch -lt $treeWidth; $branch++) {
            $position = $treeStart + $branch
            if ($branch -eq 0 -or $branch -eq ($treeWidth - 1)) {
                $line[$position] = '/'
                $colors[$position] = 'Green'
            } elseif ((($branch + $treeLayer + $Frame) % 4) -eq 0) {
                $lightIndex = ($branch + $treeLayer + $Frame) % $script:FrostLightColors.Count
                $line[$position] = 'o'
                $colors[$position] = $script:FrostLightColors[$lightIndex]
            } elseif ((($branch + (2 * $treeLayer)) % 7) -eq 0) {
                $line[$position] = '+'
                $colors[$position] = 'Red'
            } else {
                $line[$position] = '/'
                $colors[$position] = 'Green'
            }
        }
    } elseif ($treeLayer -eq $TreeHeight) {
        for ($position = 2; $position -lt (2 + (2 * $TreeHeight - 1)); $position++) {
            $line[$position] = '='
            $colors[$position] = 'Green'
        }
    } elseif ($treeLayer -le ($TreeHeight + 2)) {
        $trunk = ' ||| '
        $trunkStart = 2 + $TreeHeight - 2
        for ($index = 0; $index -lt $trunk.Length; $index++) {
            $line[$trunkStart + $index] = $trunk[$index]
            $colors[$trunkStart + $index] = 'DarkYellow'
        }
    }

    $snowColors = @('White', 'Cyan', 'Magenta', 'Yellow')
    for ($flake = 0; $flake -lt 21; $flake++) {
        $snowRow = (($flake * 5) + ($Frame * 2)) % ($TreeHeight + 4)
        if ($snowRow -ne $Layer) { continue }
        $snowColumn = (($flake * 19) + ($Frame * 5) + 41) % $width
        if ($line[$snowColumn] -eq ' ') {
            $line[$snowColumn] = @('.', '+', '*')[($flake + $Frame) % 3]
            $colors[$snowColumn] = $snowColors[($flake + $Frame) % $snowColors.Count]
        }
    }

    if ($Layer -ge 5 -and $Layer -le 9) {
        $signStart = 42
        $signText = switch ($Layer) {
            5 { '+----------------------------+' }
            6 { '|  Merry Christmas!          |' }
            7 { '|  From FrostShell  🎄       |' }
            8 { '|  Type frost-help below     |' }
            9 { '+----------------------------+' }
        }
        for ($index = 0; $index -lt $signText.Length; $index++) {
            $position = $signStart + $index
            if ($position -ge $width) { break }
            $line[$position] = $signText[$index]
            if ($Layer -eq 5 -or $Layer -eq 9 -or $index -eq 0 -or $index -eq ($signText.Length - 1)) {
                $colors[$position] = 'DarkYellow'
            } elseif ($Layer -eq 7) {
                $colors[$position] = 'Cyan'
            } elseif ($Layer -eq 8) {
                $colors[$position] = 'Green'
            } else {
                $colors[$position] = 'White'
            }
        }
    }

    $column = 0
    while ($column -lt $width) {
        $color = $colors[$column]
        $end = $column + 1
        while ($end -lt $width -and $colors[$end] -eq $color) { $end++ }
        $segment = New-Object char[] ($end - $column)
        [Array]::Copy($line, $column, $segment, 0, $segment.Length)
        Write-Host (-join $segment) -ForegroundColor $color -NoNewline
        $column = $end
    }
    Write-Host ''
}

function Write-FrostScene {
    param([int]$Frame, [int]$TreeHeight)

    Write-Host '  🎄 FROSTSHELL  *  WINTER NIGHT  ☃️' -ForegroundColor Cyan
    for ($layer = 0; $layer -lt ($TreeHeight + 4); $layer++) {
        Write-FrostSky -Frame $Frame -Layer $layer -TreeHeight $TreeHeight
    }
    Write-Host '  ✨ Snow is falling... your next command is yours.' -ForegroundColor Cyan
}

function Show-FrostTree {
    Clear-Host
    $treeHeight = 17
    $frameCount = 1
    $startTop = $null
    $cursorVisible = $null
    try {
        if (-not [Console]::IsOutputRedirected) {
            $candidateTop = [Console]::CursorTop
            if (($candidateTop + $treeHeight + 5) -lt [Console]::BufferHeight) {
                $frameCount = 7
                $startTop = $candidateTop
                $cursorVisible = [Console]::CursorVisible
            }
        }
    } catch [System.IO.IOException] {
        $frameCount = 1
    } catch [System.ArgumentOutOfRangeException] {
        $frameCount = 1
    }

    try {
        if ($frameCount -gt 1) { [Console]::CursorVisible = $false }
        for ($frame = 0; $frame -lt $frameCount; $frame++) {
            if ($frame -gt 0) { [Console]::SetCursorPosition(0, $startTop) }
            Write-FrostScene -Frame $frame -TreeHeight $treeHeight
            if ($frame -lt ($frameCount - 1)) { Start-Sleep -Milliseconds 130 }
        }
    } finally {
        if ($frameCount -gt 1 -and $null -ne $cursorVisible) {
            try { [Console]::CursorVisible = $cursorVisible } catch [System.IO.IOException] {}
        }
    }
}

function frost {
    $context = Get-FrostContext
    Show-FrostTree
    Write-Host ''
    Write-Host '  LOCATION  ' -ForegroundColor Cyan -NoNewline
    Write-Host $context.Path -ForegroundColor White
    if ($context.Branch) {
        Write-Host '  GIT       ' -ForegroundColor Cyan -NoNewline
        Write-Host $context.Branch -ForegroundColor Yellow -NoNewline
        if ($context.State -eq 'changes') {
            Write-Host '  |  CHANGES' -ForegroundColor Red
        } else {
            Write-Host '  |  CLEAN' -ForegroundColor Green
        }
    }
    Write-Host ''
}

function frost-help {
    Write-Host ''
    Write-Host '       __          __          __' -ForegroundColor Yellow
    Write-Host '  ___(o )>   ___(o )>   ___(o )>' -ForegroundColor Yellow
    Write-Host '  \ <_. )    \ <_. )    \ <_. )' -ForegroundColor DarkYellow
    Write-Host '   `---`      `---`      `---`' -ForegroundColor DarkYellow
    Write-Host ''
    Write-Host '  🦆 FROSTSHELL COMMANDS 🦆' -ForegroundColor Cyan
    Write-Host '  frost       Show the snowy scene and Git status' -ForegroundColor White
    Write-Host '  frost-tree  Replay the twinkling tree scene' -ForegroundColor White
    Write-Host '  frost-greet Hear a greeting from Santa' -ForegroundColor White
    Write-Host '  frost-help  Show the duck parade and this list' -ForegroundColor White
    if (-not $isDotSourced) {
        Write-Host ''
        Write-Host '  CMD commands are available after starting windows\FrostShell.cmd.' -ForegroundColor DarkGray
    }
}

function frost-greet {
    $greetings = @(
        'Ho ho ho! May your builds be bright and your bugs take the night off!',
        'Merry Christmas! Santa hopes your cocoa is warm and your commits are clean.',
        'Happy holidays! Keep a little wonder in every line of code.',
        'Ho ho ho! Wishing you a cozy, cheerful, wonderfully festive season!'
    )
    Write-Host ("  🎅 Santa says: " + ($greetings | Get-Random) + ' 🎄') -ForegroundColor Yellow
}

function global:prompt {
    $context = Get-FrostContext
    $lightColor = $script:FrostLightColors[([int](Get-Date -Format 'ss') % $script:FrostLightColors.Count)]
    Write-Host ''
    Write-Host '  o' -ForegroundColor $lightColor -NoNewline
    Write-Host ' FROST' -ForegroundColor Green -NoNewline
    Write-Host "  $($context.Time)" -ForegroundColor Cyan
    Write-Host "  $($context.Path)" -ForegroundColor White -NoNewline
    if ($context.Branch) {
        Write-Host "  |  $($context.Branch)" -ForegroundColor Yellow -NoNewline
        if ($context.State -eq 'changes') {
            Write-Host '  |  CHANGES' -ForegroundColor Red -NoNewline
        } else {
            Write-Host '  |  CLEAN' -ForegroundColor Green -NoNewline
        }
    }
    Write-Host ''
    Write-Host '  >' -ForegroundColor Green -NoNewline
    return ' '
}

function Set-FrostSessionTheme {
    if ($null -eq $global:FrostShellOriginalColors) {
        $global:FrostShellOriginalColors = [pscustomobject]@{
            Background = $Host.UI.RawUI.BackgroundColor
            Foreground = $Host.UI.RawUI.ForegroundColor
            Title = $Host.UI.RawUI.WindowTitle
        }
    }
    $Host.UI.RawUI.BackgroundColor = 'Black'
    $Host.UI.RawUI.ForegroundColor = 'White'
    $Host.UI.RawUI.WindowTitle = 'FrostShell | Winter night'
    Clear-Host
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

$isDotSourced = $MyInvocation.InvocationName -eq '.'
if ($isDotSourced) {
    Set-FrostSessionTheme
    if (-not $global:FrostShellWelcomeShown) {
        Show-FrostTree
        $global:FrostShellWelcomeShown = $true
    }
} else {
    switch ($Action) {
        'Welcome' { frost }
        'Tree' { Show-FrostTree; (Get-FrostContext | Out-Null) }
        'Greet' { frost-greet }
        'Help' { frost-help }
    }
}
