#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this setup script as root."
    exit 1
fi

# Define file paths
RESET_SCRIPT_SOURCE="./reset_i225v.sh"
MONITOR_SCRIPT_SOURCE="./monitor_igc.sh"
SERVICE_FILE_SOURCE="./igc_monitor.service"

RESET_SCRIPT_DEST="/usr/local/bin/reset_i225v.sh"
MONITOR_SCRIPT_DEST="/usr/local/bin/monitor_igc.sh"
SERVICE_FILE_DEST="/etc/systemd/system/igc_monitor.service"

# Copy the reset script
if [ -f "$RESET_SCRIPT_SOURCE" ]; then
    echo "Copying reset script to $RESET_SCRIPT_DEST..."
    cp "$RESET_SCRIPT_SOURCE" "$RESET_SCRIPT_DEST"
    chmod 755 "$RESET_SCRIPT_DEST"
else
    echo "Reset script not found at $RESET_SCRIPT_SOURCE"
    exit 1
fi

# Copy the monitoring script
if [ -f "$MONITOR_SCRIPT_SOURCE" ]; then
    echo "Copying monitoring script to $MONITOR_SCRIPT_DEST..."
    cp "$MONITOR_SCRIPT_SOURCE" "$MONITOR_SCRIPT_DEST"
    chmod 755 "$MONITOR_SCRIPT_DEST"
else
    echo "Monitoring script not found at $MONITOR_SCRIPT_SOURCE"
    exit 1
fi

# Copy the systemd service file
if [ -f "$SERVICE_FILE_SOURCE" ]; then
    echo "Copying service file to $SERVICE_FILE_DEST..."
    cp "$SERVICE_FILE_SOURCE" "$SERVICE_FILE_DEST"
    chmod 644 "$SERVICE_FILE_DEST"
else
    echo "Service file not found at $SERVICE_FILE_SOURCE"
    exit 1
fi

# Reload systemd daemon
echo "Reloading systemd daemon..."
systemctl daemon-reload

# Enable and start the service
echo "Enabling and starting igc_monitor.service..."
systemctl enable igc_monitor.service
systemctl start igc_monitor.service

echo "Setup completed successfully."
