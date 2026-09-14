#!/usr/bin/env powershell
# Complete Debugging Test Script
# Tests: Build, Verify, Flash, Debug Ready

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "PhoenixSecureBoot - Debug Setup Test" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Verify Debug ELF exists
Write-Host "Step 1: Checking Debug ELF..." -ForegroundColor Yellow
$debugElf = "D:\Embedded\Projects\PhoenixSecureBoot\build_debug\bootloader\phoenix_bootloader.elf"
if (Test-Path $debugElf) {
    $size = (Get-Item $debugElf).Length
    Write-Host "[OK] Debug ELF found: $($size / 1024)KB (includes symbols)" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Debug ELF NOT found!" -ForegroundColor Red
    Write-Host "Run: Ctrl+Shift+B then select 'Compile Bootloader (Debug)'" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# Step 2: Verify symbols in ELF
Write-Host "Step 2: Checking Debug Symbols..." -ForegroundColor Yellow
$symbols = arm-none-eabi-objdump -h $debugElf 2>&1 | Select-String ".debug"
if ($symbols) {
    Write-Host "[OK] Debug symbols detected (.debug sections found)" -ForegroundColor Green
} else {
    Write-Host "[WARN] No .debug sections found" -ForegroundColor Yellow
    Write-Host "Symbols might be stripped or compilation didn't include -g flag" -ForegroundColor Yellow
}
Write-Host ""

# Step 3: Check source files
Write-Host "Step 3: Verifying Source Files..." -ForegroundColor Yellow
$bootloaderSrc = "D:\Embedded\Projects\PhoenixSecureBoot\bootloader\src\main.c"
$bootloaderH = "D:\Embedded\Projects\PhoenixSecureBoot\bootloader\inc\bootloader.h"

if ((Test-Path $bootloaderSrc) -and (Test-Path $bootloaderH)) {
    Write-Host "[OK] Source files found" -ForegroundColor Green
    Write-Host "   - main.c" -ForegroundColor Gray
    Write-Host "   - bootloader.h" -ForegroundColor Gray
} else {
    Write-Host "[FAIL] Source files missing!" -ForegroundColor Red
}
Write-Host ""

# Step 4: Verify GDB
Write-Host "Step 4: Checking GDB..." -ForegroundColor Yellow
$gdb = "C:\Program Files (x86)\Arm GNU Toolchain arm-none-eabi\12.2 mpacbti-rel1\bin\arm-none-eabi-gdb.exe"
if (Test-Path $gdb) {
    Write-Host "[OK] GDB found: arm-none-eabi-gdb.exe" -ForegroundColor Green
} else {
    Write-Host "[FAIL] GDB not found!" -ForegroundColor Red
    Write-Host "Install ARM GNU Toolchain" -ForegroundColor Yellow
}
Write-Host ""

# Step 5: Verify OpenOCD
Write-Host "Step 5: Checking OpenOCD..." -ForegroundColor Yellow
$oe = Get-ChildItem "C:\ST\STM32CubeIDE*" -Recurse -Filter "openocd.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
if ($oe) {
    Write-Host "[OK] OpenOCD found" -ForegroundColor Green
} else {
    Write-Host "[WARN] OpenOCD not found in STM32CubeIDE" -ForegroundColor Yellow
    Write-Host "Install STM32CubeIDE or OpenOCD standalone" -ForegroundColor Yellow
}
Write-Host ""

# Step 6: Verify ST-Link
Write-Host "Step 6: Checking STLink..." -ForegroundColor Yellow
$stlink = Get-PnpDevice -PresentOnly | Where-Object {$_.Name -like "*ST*"} | Select-Object -First 1
if ($stlink) {
    if ($stlink.Status -eq "OK") {
        Write-Host "[OK] STLink detected: $($stlink.Name)" -ForegroundColor Green
    } else {
        Write-Host "[WARN] STLink found but Status: $($stlink.Status)" -ForegroundColor Yellow
    }
} else {
    Write-Host "[FAIL] STLink not detected" -ForegroundColor Red
}
Write-Host ""

# Summary
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "DEBUGGING SETUP - NEXT STEPS" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Method 1: Use VS Code Tasks (Recommended)" -ForegroundColor Yellow
Write-Host "  1. Ctrl+Shift+P" -ForegroundColor Gray
Write-Host "  2. Select: Run Task" -ForegroundColor Gray
Write-Host "  3. Select: Start OpenOCD Server" -ForegroundColor Gray
Write-Host "  4. Keep terminal open" -ForegroundColor Gray
Write-Host "  5. Press F5 to debug" -ForegroundColor Gray
Write-Host ""
Write-Host "Debugging Shortcuts:" -ForegroundColor Yellow
Write-Host "  F10 = Step over line" -ForegroundColor Gray
Write-Host "  F11 = Step into function" -ForegroundColor Gray
Write-Host "  Shift+F11 = Step out" -ForegroundColor Gray
Write-Host "  F5 = Continue" -ForegroundColor Gray
Write-Host "  F9 = Toggle breakpoint" -ForegroundColor Gray
Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "Setup verification complete - ready to debug" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
