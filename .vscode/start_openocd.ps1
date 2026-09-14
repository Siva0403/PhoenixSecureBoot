#!/usr/bin/env powershell
# Start OpenOCD server for debugging
# Uses the configuration embedded in STM32CubeIDE

$oe = Get-ChildItem "C:\ST\STM32CubeIDE*" -Recurse -Filter "openocd.exe" | Select-Object -First 1

if (-not $oe) {
    Write-Host "❌ OpenOCD not found in STM32CubeIDE" -ForegroundColor Red
    Write-Host "Trying to download standalone OpenOCD..." -ForegroundColor Yellow
    exit 1
}

$oeExe = $oe.FullName
$oeDir = Split-Path $oeExe

Write-Host "🔍 Starting OpenOCD Server..." -ForegroundColor Cyan
Write-Host "Path: $oeExe" -ForegroundColor Gray
Write-Host ""

# Try with embedded configuration
Push-Location $oeDir

# Create inline TCL configuration for STM32F401
$tcl_config = @"
# STM32F401 debug configuration
source [find interface/stlink.cfg]
source [find target/stm32f4x.cfg]
"@

# Try to run with inline config
& $oeExe -c "set WORKAREASIZE 0x20000" `
         -c "adapter speed 100" `
         -f interface/stlink.cfg `
         -f target/stm32f4x.cfg `
         -c "gdb_port 3333" `
         -c "tcl_port 6666" `
         -c "telnet_port 4444"

Pop-Location
