# OpenOCD Installation Fix

## Problem
STM32CubeIDE's bundled OpenOCD is **missing config files** (`/share/openocd` directory).
This prevents debugging in VS Code.

## Solution: Install Standalone OpenOCD

### Option 1: Pre-Built Binary (Fastest)

1. Download from: https://github.com/xpack-dev-tools/openocd-xpack/releases
   - Look for: `openocd-0.12.0-1-win32-x64.zip` or latest version
   - Extract to: `C:\tools\openocd` (create if needed)

2. Verify installation:
   ```powershell
   C:\tools\openocd\bin\openocd.exe --version
   ```
   Should show version + available adapters

3. Update `.vscode/tasks.json` to use new path:
   ```powershell
   "C:\tools\openocd\bin\openocd.exe" -f interface/stlink.cfg -f target/stm32f4x.cfg
   ```

### Option 2: Build from Source

1. Install MSYS2 or use WSL
2. Clone: `git clone --recurse-submodules https://github.com/openocd-org/openocd.git`
3. Build: `./configure && make && make install`

### Option 3: Use MinGW Pre-Built

Download from: http://gnutoolchains.com/arm-eabi/
- Contains complete OpenOCD with all configs

## Verify After Installation

```powershell
# Should show all available adapters
openocd.exe -c "adapter driver"

# Should find config files
openocd.exe -f interface/stlink.cfg -f target/stm32f4x.cfg 2>&1 | head -20
```

## After Installation

Once OpenOCD is installed properly:
1. Restart VS Code
2. Run Task: "Start OpenOCD Server" 
3. Press F5 to debug

---

**Quickest Fix:** Download xpack pre-built binary from option 1 (5 min setup)
