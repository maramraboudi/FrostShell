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
    param([int]$Frame)

    $width = 76
    $colors = @('DarkGray', 'Cyan', 'Magenta', 'White', 'Yellow')
    for ($row = 0; $row -lt 3; $row++) {
        $line = New-Object char[] $width
        for ($column = 0; $column -lt $width; $column++) { $line[$column] = ' ' }
        for ($column = 3; $column -lt $width; $column += 7) {
            $position = ($column + (11 * $row) + (3 * $Frame)) % $width
            $spark = @('.', '+', '*')[($row + $column + $Frame) % 3]
            $line[$position] = $spark
        }
        for ($column = 0; $column -lt $width; $column++) {
            if ($line[$column] -eq ' ') {
                Write-Host ' ' -NoNewline
            } else {
                $color = $colors[($column + $row + $Frame) % $colors.Count]
                Write-Host $line[$column] -ForegroundColor $color -NoNewline
            }
        }
        Write-Host ''
    }
}

function Write-FrostTreeFrame {
    param([int]$Frame)

    Write-Host (' ' * 10) -NoNewline
    Write-Host '*' -ForegroundColor Yellow
    for ($layer = 0; $layer -lt 12; $layer++) {
        $width = 1 + (2 * $layer)
        $indent = 11 - $layer
        Write-Host (' ' * $indent) -NoNewline
        for ($column = 0; $column -lt $width; $column++) {
            $isLight = (($column + (2 * $layer) + $Frame) % 6) -eq 0
            if ($isLight) {
                $colorIndex = ($column + $layer + $Frame) % $script:FrostLightColors.Count
                Write-Host 'o' -ForegroundColor $script:FrostLightColors[$colorIndex] -NoNewline
            } elseif ((($column + $layer) % 9) -eq 0) {
                Write-Host '+' -ForegroundColor Red -NoNewline
            } else {
                Write-Host '/' -ForegroundColor Green -NoNewline
            }
        }
        $signRow = $null
        switch ($layer) {
            4 { $signRow = '  +--------------------------+' }
            5 { $signRow = '  |  🎄 MERRY CHRISTMAS!      |' }
            6 { $signRow = '  |  Welcome to FrostShell  |' }
            7 { $signRow = '  |  Type frost-help below  |' }
            8 { $signRow = '  +--------------------------+' }
        }
        if ($signRow) {
            $spacesToSign = [Math]::Max(2, 39 - $indent - $width)
            Write-Host (' ' * $spacesToSign) -NoNewline
            if ($layer -in 4, 8) {
                Write-Host $signRow -ForegroundColor DarkYellow
            } else {
                Write-Host '  | ' -ForegroundColor DarkYellow -NoNewline
                if ($layer -eq 5) {
                    Write-Host '🎄 MERRY CHRISTMAS!' -ForegroundColor White -NoNewline
                    Write-Host '      |' -ForegroundColor DarkYellow
                } elseif ($layer -eq 6) {
                    Write-Host 'Welcome to FrostShell' -ForegroundColor Cyan -NoNewline
                    Write-Host '  |' -ForegroundColor DarkYellow
                } else {
                    Write-Host 'Type frost-help below' -ForegroundColor Yellow -NoNewline
                    Write-Host '  |' -ForegroundColor DarkYellow
                }
            }
        } else {
            Write-Host ''
        }
    }
    Write-Host (' ' * 9) -NoNewline
    Write-Host '|||' -ForegroundColor DarkYellow
    Write-Host (' ' * 7) -NoNewline
    Write-Host '=========' -ForegroundColor Green
}

function Write-FrostScene {
    param([switch]$Animate)

    Write-Host '  🎄 FROSTSHELL  ' -ForegroundColor Cyan -NoNewline
    Write-Host ' *  Winter night edition  ☃️' -ForegroundColor Yellow
    Write-FrostSky -Frame ([int](Get-Date -Format 'ss') % 3)
    $frameCount = 1
    if ($Animate -and -not [Console]::IsOutputRedirected -and
        ([Console]::CursorTop + 18) -lt [Console]::BufferHeight) {
        $frameCount = 4
    }
    for ($frame = 0; $frame -lt $frameCount; $frame++) {
        if ($frame -gt 0) {
            $top = [Console]::CursorTop - 15
            [Console]::SetCursorPosition(0, $top)
        }
        Write-FrostTreeFrame -Frame $frame
        if ($frame -lt ($frameCount - 1)) { Start-Sleep -Milliseconds 180 }
    }
    Write-Host ''
    Write-Host '  ✨ Snow is falling... your next command is yours.' -ForegroundColor Cyan
    Write-Host '  Try: frost-help  |  frost-greet' -ForegroundColor DarkGray
}

function Show-FrostTree {
    Clear-Host
    Write-FrostScene -Animate
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
    Write-Host '  FrostShell commands' -ForegroundColor Cyan
    Write-Host '  frost       Show the winter scene and current Git status' -ForegroundColor White
    Write-Host '  frost-tree  Replay the twinkling tree scene' -ForegroundColor White
    Write-Host '  frost-greet Show a festive greeting' -ForegroundColor White
    Write-Host '  frost-help  Show this command list' -ForegroundColor White
    if (-not $isDotSourced) {
        Write-Host ''
        Write-Host '  CMD aliases are available after calling windows\FrostShell.cmd.' -ForegroundColor DarkGray
    }
}

function frost-greet {
    $greetings = @(
        'Merry Christmas! May your builds be bright. 🎄',
        'Happy holidays! Wishing you a cozy coding season. ❄️',
        'May your commits be clean and your cocoa warm. ☕',
        'Season''s greetings, and happy debugging! ✨'
    )
    Write-Host ("  " + ($greetings | Get-Random)) -ForegroundColor Yellow
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
