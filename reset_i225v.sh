#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

# Get the list of PCI addresses for Ethernet Controller I225-V (rev 03)
device_list=$(lspci -D | grep "Ethernet Controller I225-V (rev 03)" | awk '{print $1}')

# Check if any devices were found
if [ -z "$device_list" ]; then
    echo "No Ethernet Controller I225-V (rev 03) devices found."
    exit 0
fi

# Loop over each device
for device in $device_list; do
    echo "Removing device $device..."
    # Remove the device
    echo 1 > "/sys/bus/pci/devices/$device/remove"
    # Check if the removal was successful
    if [ $? -ne 0 ]; then
        echo "Failed to remove device $device."
        exit 1
    fi
done

# Rescan the PCI bus
echo "Rescanning the PCI bus..."
echo 1 > /sys/bus/pci/rescan
if [ $? -ne 0 ]; then
    echo "Failed to rescan the PCI bus."
    exit 1
fi

echo "Operation completed successfully."
