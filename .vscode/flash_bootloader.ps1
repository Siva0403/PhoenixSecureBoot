# Flash Bootloader via STM32CubeProgrammer
# This script flashes the compiled bootloader to the STM32F411xE

$programmerPath = "C:\Program Files\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe"
$firmwarePath = "$PSScriptRoot\..\build\bootloader\phoenix_bootloader.elf"
$buildDir = "$PSScriptRoot\..\build"

# Check if firmware exists
if (-not (Test-Path $firmwarePath)) {
    Write-Host "❌ Error: Firmware not found at $firmwarePath" -ForegroundColor Red
    Write-Host "Make sure you've compiled the bootloader first!" -ForegroundColor Yellow
    exit 1
}

Write-Host "🔌 Flashing bootloader to STM32F401xE..." -ForegroundColor Cyan
Write-Host "Firmware: $(Split-Path $firmwarePath -Leaf)" -ForegroundColor Gray
Write-Host "Using: STM32CubeProgrammer" -ForegroundColor Gray
Write-Host ""

# Flash the firmware
& $programmerPath -c port=SWD -d $firmwarePath -Rst

# Check result
if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Bootloader flashed successfully!" -ForegroundColor Green
    Write-Host "Board reset. Ready for testing." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "❌ Flashing failed with exit code: $LASTEXITCODE" -ForegroundColor Red
    exit 1
}
