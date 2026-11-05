@echo off
if /i "%FROSTSHELL_PATH_ADDED%"=="1" goto path_ready
for %%I in ("%~dp0..") do set "FROSTSHELL_ROOT=%%~fI"
set "PATH=%FROSTSHELL_ROOT%;%PATH%"
set "FROSTSHELL_PATH_ADDED=1"
:path_ready

if /i "%~1"=="/tree" goto tree
if /i "%~1"=="/greet" goto greet
if /i "%~1"=="/help" goto help

cd /d "%~dp0.."
chcp 65001 >nul
title FrostShell - Winter Terminal
color 1F
cls

where.exe powershell.exe >nul 2>nul
if errorlevel 1 (
    echo FrostShell needs Windows PowerShell 5.1 or later.
    exit /b 1
)

powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0FrostShell.ps1" -Action Welcome
if errorlevel 1 exit /b 1

prompt $E[93m🎄$E[0m $E[92mFROST$E[0m $E[96m$T$E[0m$_$E[97m$P$E[0m $E[93m$G$E[0m
echo.
echo   Ready: frost  ^|  frost-tree  ^|  frost-greet  ^|  frost-help
exit /b 0

:tree
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0FrostShell.ps1" -Action Tree
exit /b %errorlevel%

:greet
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0FrostShell.ps1" -Action Greet
exit /b %errorlevel%

:help
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0FrostShell.ps1" -Action Help
exit /b %errorlevel%
