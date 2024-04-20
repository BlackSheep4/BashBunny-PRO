#!/bin/bash

# Sourcing the function update_os inside main.sh
source $HOME/bashbunny/config/main.sh

function update_os() {
    # Update the system
    log "[+] Updating the system. Be patient"
    apt update -y >> "$log_file" 2>&1

    if [[ $? -eq 0 ]]; then
        log "[+] System updated successfully"
    else
        log "[!] System has not been updated due an error. Please try again later"
        exit 1
    fi

    # Upgrade the system
    log "[!] Upgrading the system. Be patient"
    apt upgrade -y >> "$log_file" 2>&1
    if [[ $? -eq 0 ]]; then
        log "[+] System upgrade completed successfully."
    else
        log "[!] System has not been updated due an error. Please try again later"
        exit 1
    fi
}

