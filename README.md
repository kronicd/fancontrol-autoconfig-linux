# Fancontrol Autoconfig

Fan control on Linux often breaks after a reboot or kernel update because `hwmon` IDs (like `hwmon1` vs `hwmon2`) get reordered. This makes a static `/etc/fancontrol` file point to the wrong place.

This tool solves that by dynamically resolving sensor paths by driver name every time the service starts.

## Features
- **Dynamic IDs**: Resolves `hwmon` indices on every boot.
- **Multi-Fan**: Map as many fans as your hardware supports.
- **Robust**: Uses hardware-level paths (`DEVPATH`).
- **Set and forget**: Install it once and let it handle the rest.

## Install

1. **Clone**:
   ```bash
   git clone <repo_url>
   cd fancontrol-autoconfig
   ```

2. **Install**:
   ```bash
   sudo ./install.sh
   ```

## Configuration
Edit the arrays at the top of `update-fancontrol-config.sh` to match your hardware:

```bash
PWM_PINS=("pwm2" "pwm1")
TEMP_INPUTS=("temp1_input" "temp2_input")
FAN_INPUTS=("fan2_input" "fan1_input")
```

## Finding your driver and pins

You need to know which sensors and PWM controls to map.

### 1. Find the drivers
Run `sensors`. Look for the section headers:
*   **CPU**: Usually `coretemp`.
*   **Fans**: Look for chip names like `nct6779`, `it8728`, or `aspeed`.

### 2. Map the PWM pins
Run `sudo pwmconfig`. This tool stops fans one by one to help you identify them.
*   If `pwm2` stops and `fan2_input` drops to 0 RPM, you found the right pin.
*   Note these names for the configuration script.

### 3. Choose a temp sensor
Usually, the CPU fan should follow `temp1_input` (often labeled `Package id 0` in `sensors` output).

### 4. Verify filenames
Check the hardware monitor folder for the exact names:
```bash
# Find the folder for your driver (e.g., nct6779)
grep . /sys/class/hwmon/hwmon*/name

# List contents
ls /sys/class/hwmon/hwmonX/
```
Use the exact filenames (like `pwm2` or `temp1_input`) in the script.

> **Note**: If `pwmconfig` doesn't work, check your BIOS. You might need to set the fan mode to "Manual" or "Full Speed" to allow the OS to take control.

## Dependencies
- `fancontrol` & `lm-sensors`
- `systemd`
- `grep`, `sed`, `readlink`.

## How it works
The installer adds a `systemd` override. Before the `fancontrol` service starts, it runs `update-fancontrol-config.sh` to build a fresh `/etc/fancontrol` based on your current hardware IDs.
