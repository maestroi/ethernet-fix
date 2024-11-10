Ethernet Controller I225-V Automatic Reset Service

This project provides an automated solution to monitor and reset the Intel Ethernet Controller I225-V (rev 03) when it encounters driver crashes. It includes:

A reset script to remove and rescan the PCI device.
A monitoring script that watches kernel logs for specific error messages.
A systemd service to run the monitoring script in the background.
Table of Contents

Overview
Prerequisites
Installation
Usage
Configuration
Logging and Monitoring
Uninstallation
Notes and Considerations
License
Overview

The Intel Ethernet Controller I225-V (rev 03) may sometimes experience driver crashes, leading to loss of network connectivity. When such crashes occur, the kernel logs error messages like:

igc 0000:0a:00.0 eno1: PCIe link lost, device now detached
igc: Failed to read reg
This project automates the detection of these errors and resets the Ethernet controller to restore connectivity, minimizing downtime and manual intervention.

Prerequisites

Operating System: Linux (tested on Ubuntu-based systems)
Privileges: Root access to install and run the scripts
Systemd: For service management
Bash Shell: To execute the scripts
Installation

1. Clone the Repository
git clone https://github.com/yourusername/ethernet-controller-reset.git
cd ethernet-controller-reset
2. Run the Setup Script
Ensure the setup script is executable:

chmod +x setup_igc_monitor.sh
Run the setup script with root privileges:

sudo ./setup_igc_monitor.sh
What the Setup Script Does:

Copies the reset script to /usr/local/bin/reset_i225v.sh
Copies the monitoring script to /usr/local/bin/monitor_igc.sh
Copies the systemd service file to /etc/systemd/system/igc_monitor.service
Sets appropriate permissions for the scripts and service file
Reloads the systemd daemon
Enables and starts the igc_monitor service
Usage

The service runs in the background and automatically monitors kernel logs for error messages indicating a driver crash. When such an error is detected, the service executes the reset script to recover the Ethernet controller.

Checking Service Status
sudo systemctl status igc_monitor.service
Viewing Service Logs
sudo journalctl -u igc_monitor.service
Configuration

Adjusting Error Patterns
If the error messages in your kernel logs differ, you can adjust the patterns in the monitoring script.

Edit the Monitoring Script:

sudo nano /usr/local/bin/monitor_igc.sh
Modify the Patterns:

PATTERN1="your new pattern here"
PATTERN2="another pattern here"
Modifying the Reset Script
If you need to adjust the reset procedure (e.g., for a different device), edit the reset script:

sudo nano /usr/local/bin/reset_i225v.sh
Logging and Monitoring

The service uses systemd-cat to log messages with the identifier igc_monitor. This makes it easy to track its activity using journalctl.

View Logs by Identifier:

sudo journalctl -t igc_monitor
Sample Log Entries:

Nov 11 12:00:00 yourhostname igc_monitor: Detected igc driver crash. Resetting the device...
Nov 11 12:00:01 yourhostname igc_monitor: Removing device 0000:0a:00.0...
Nov 11 12:00:02 yourhostname igc_monitor: Rescanning the PCI bus...
Nov 11 12:00:03 yourhostname igc_monitor: Operation completed successfully.
Nov 11 12:00:03 yourhostname igc_monitor: Device reset successfully.
Uninstallation

To remove the service and scripts from your system:

1. Stop and Disable the Service
sudo systemctl stop igc_monitor.service
sudo systemctl disable igc_monitor.service
2. Remove Files
sudo rm /etc/systemd/system/igc_monitor.service
sudo rm /usr/local/bin/monitor_igc.sh
sudo rm /usr/local/bin/reset_i225v.sh
3. Reload the Systemd Daemon
sudo systemctl daemon-reload
Notes and Considerations

Root Privileges: The scripts require root access to modify system hardware configurations.
Security: Ensure only authorized users can modify the scripts and service files.
Testing: It's recommended to test the scripts in a controlled environment before deploying.
Adjust Patterns Carefully: When modifying error patterns, ensure they match the actual log messages to avoid false positives or missed detections.
Service Updates: If you update any scripts, remember to reload the systemd daemon and restart the service:
sudo systemctl daemon-reload
sudo systemctl restart igc_monitor.service
License

This project is licensed under the MIT License.

Additional Information

Testing the Setup
To verify that the monitoring service and reset script are functioning correctly, you can simulate an error message:

logger -p kern.err "igc 0000:0a:00.0 eno1: PCIe link lost, device now detached"
Check the logs to see if the reset was triggered:

sudo journalctl -t igc_monitor
Troubleshooting
Service Not Starting:
Check the status for error messages:
sudo systemctl status igc_monitor.service
Ensure the scripts are executable and located at the correct paths.
Logs Not Appearing:
Confirm that SyslogIdentifier is set correctly in the service file.
Ensure systemd-cat is being called in the scripts for logging.
No Devices Found:
Verify that the reset script correctly identifies your Ethernet controller.
Run the following command to check for devices:
lspci -D | grep "Ethernet Controller I225-V (rev 03)"
Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements.

Acknowledgments

Thanks to the community for providing insights into monitoring and resetting hardware devices via scripts and systemd services.
Disclaimer: Automating system-level operations can be powerful but may also carry risks. Ensure you understand the scripts and have proper backups before deployment. The author is not responsible for any damage or data loss.