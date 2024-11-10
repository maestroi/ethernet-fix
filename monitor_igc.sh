#!/bin/bash

# Path to the reset script
RESET_SCRIPT="/usr/local/bin/reset_i225v.sh"

# Patterns to look for
PATTERN1="igc .*: PCIe link lost, device now detached"
PATTERN2="igc: Failed to read reg"

# Function to perform the reset
perform_reset() {
    echo "$(date): Detected igc driver crash. Resetting the device..." | systemd-cat -t igc_monitor
    sudo "$RESET_SCRIPT"
    if [ $? -eq 0 ]; then
        echo "$(date): Device reset successfully." | systemd-cat -t igc_monitor
    else
        echo "$(date): Device reset failed." | systemd-cat -t igc_monitor
    fi
}

# Ensure the reset script exists and is executable
if [ ! -x "$RESET_SCRIPT" ]; then
    echo "Reset script not found or not executable at $RESET_SCRIPT" | systemd-cat -t igc_monitor
    exit 1
fi

# Monitor the kernel log using journalctl
journalctl -k -f --since "now" | while read -r line; do
    if [[ "$line" =~ $PATTERN1 ]] || [[ "$line" =~ $PATTERN2 ]]; then
        perform_reset
    fi
done
