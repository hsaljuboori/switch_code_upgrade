#!/bin/bash

# Enhanced pre-upgrade check script for Cisco Nexus 9K switches

# Redirect stdout and stderr to a log file
log_file="postupgrade_check_logs_enhanced1.log"
exec &> >(tee -a "$log_file")

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
    echo "Pre-checks for ${switch_ip} - Disk Space:"
    execute_ssh "show system resources | include bootflash"

    # Check Interface Status
    echo "Pre-checks for ${switch_ip} - Interface Status:"
    execute_ssh "show interface brief"

    # Run a show version command
    echo "Pre-checks for ${switch_ip} - Show Version:"
    show_version_output=$(execute_ssh "show version")
    echo "$show_version_output"

    echo "--------------------------------------------------------"
    echo "Pre-upgrade checks passed for ${switch_ip}!"
}

# Example: Run pre-checks for multiple switches
switch_ips=("192.168.86.28" "192.168.86.135")

for switch_ip in "${switch_ips[@]}"; do
    run_prechecks "$switch_ip"
done

