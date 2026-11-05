@echo off
where.exe powershell.exe >nul 2>nul
if errorlevel 1 (
    echo FrostShell needs Windows PowerShell 5.1 or later.
    exit /b 1
)

powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0FrostShell.ps1"
if errorlevel 1 exit /b 1

prompt $E[93m*$E[0m $E[32m$P$E[0m $E[90m$T$E[0m $E[33m$G$E[0m
