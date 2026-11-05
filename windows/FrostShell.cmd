@echo off
cd /d "%~dp0.."
title FrostShell - Winter Terminal
color 1F
cls

where.exe powershell.exe >nul 2>nul
if errorlevel 1 (
    echo FrostShell needs Windows PowerShell 5.1 or later.
    exit /b 1
)

powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0FrostShell.ps1"
if errorlevel 1 exit /b 1

prompt $E[93m*$E[0m $E[92mFROST$E[0m $E[96m$T$E[0m$_$E[97m$P$E[0m $E[93m$G$E[0m
