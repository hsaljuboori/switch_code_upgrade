#!/bin/bash

# Pre-upgrade check script for Cisco Nexus 9K switches

# Redirect stdout and stderr to a log file
log_file="/path/to/your/preupgrade_check.log"
exec &> "$log_file"

echo "Starting pre-upgrade checks..."

# Prompt user for password securely
read -s -p "Enter password for all switches: " switch_password
echo  # Move to a new line after password input

# Function to run pre-checks for a specific switch
run_prechecks() {
    switch_ip=$1

    # Function to execute SSH command and handle errors
    execute_ssh() {
        sshpass -p "$switch_password" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 "admin@${switch_ip}" "$1"
        if [ $? -ne 0 ]; then
            echo "Error: SSH command failed for ${switch_ip}. Check the logs for details."
            exit 1
        fi
    }

    # Check Disk Space
    execute_ssh "show system resources | include bootflash"

    # Check Interface Status
    execute_ssh "show interface brief"

    # Run a show version command
    show_version_output=$(execute_ssh "show version")
    echo "Show version command executed successfully for ${switch_ip}:"
    echo "$show_version_output"
    echo "Pre-upgrade checks passed for ${switch_ip}!"
}

# Example: Run pre-checks for multiple switches
switch_ips=("switch1_ip" "switch2_ip" "switch3_ip")

for switch_ip in "${switch_ips[@]}"; do
    run_prechecks "$switch_ip"
done

