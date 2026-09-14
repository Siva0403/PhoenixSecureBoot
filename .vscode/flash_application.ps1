# Flash Application via STM32CubeProgrammer
# This script flashes the compiled application to the STM32F401xE

$programmerPath = "C:\Program Files\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe"
$firmwarePath = "$PSScriptRoot\..\build\application\phoenix_application.elf"
$buildDir = "$PSScriptRoot\..\build"

# Check if firmware exists
if (-not (Test-Path $firmwarePath)) {
    Write-Host "❌ Error: Application firmware not found at $firmwarePath" -ForegroundColor Red
    Write-Host "Make sure you've compiled the application first!" -ForegroundColor Yellow
    exit 1
}

Write-Host "🔌 Flashing application to STM32F401xE..." -ForegroundColor Cyan
Write-Host "Firmware: $(Split-Path $firmwarePath -Leaf)" -ForegroundColor Gray
Write-Host "Address: 0x08010000 (after bootloader)" -ForegroundColor Gray
Write-Host "Using: STM32CubeProgrammer" -ForegroundColor Gray
Write-Host ""

# Flash the firmware at 0x08010000 (after bootloader)
& $programmerPath -c port=SWD -d $firmwarePath 0x08010000 -Rst

# Check result
if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Application flashed successfully!" -ForegroundColor Green
    Write-Host "Board reset. Ready for testing." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "❌ Flashing failed with exit code: $LASTEXITCODE" -ForegroundColor Red
    exit 1
}
