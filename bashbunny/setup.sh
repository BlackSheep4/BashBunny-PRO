#!/bin/bash

# Global variables
metasploit_package='https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb'
ssh_path="$HOME/.ssh/id_rsa"
log_file="/var/log/bashbunny-logs.log"

# Prepare log file
touch "$log_file"
chmod 664 "$log_file"

# Add program to path
echo "export PATH="$HOME/bin:$PATH"" >> ~/.bashrc
source ~/.bashrc

# Control the output
trap ctrl_c INT

function ctrl_c() {
    log "[!] Exiting..."
    exit 0
}

function log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >> "$log_file"
}


# Show banner
function banner() {
    clear
    source config/banner.sh
}

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

# Install all dependencies
function dependencies() {
    log "[+] Installing dependencies. Be patient"
    
    # Metasploit
    log "[!] Installing Metasploit"
    curl -o msfinstall $metasploit_package > /dev/null 2>&1 && chmod 755 msfinstall > /dev/null 2>&1

    if [[ $? -eq 0 ]]; then
        log "[+] Metasploit installed successfully"
    else
        log "[!] Metasploit has not been installed due an error. Please try again later"
        exit 1
    fi

    # Git
    log "[+] Installing git"
    apt install git -y > /dev/null

    if [[ $? -eq 0 ]]; then
        log "[+] Git installed successfully"
    else
        log "[!] Git has not been installed due an error. Please try again later"
        exit 1
    fi

    # SSH
    log "[+] Installing ssh"
    apt install ssh -y > /dev/null

    if [[ $? -eq 0 ]]; then
        log "[+] SSH installed successfully"
        log "[!] Generating keys..."
        ssh-keygen -t rsa -b 2048 -f "$ssh_path" -N "" >> "$log_file" 2>&1
        if [[ $? -eq 0 ]]; then
            log "SSH Keys successfully generated in: $ssh_path"
        else
            log "SSH Keys has not been created due an error. Please try again later"
            exit 1
        fi
    else
        log "[!] SSH has not been installed due an error. Please try again later"
        exit 1
    fi

    # Snap installation
    log "[+] Installing snap"
    apt install snap -y > /dev/null
    if [[ $? -eq 0 ]]; then
        log "[+] Snap installed successfully"
    else
        log "[!] Snap has not been installed due an error. Please try again later"
        exit 1
    fi

    # ngrok installation
    log "[+] Installing ngrok"
    snap install ngrok
    if [[ $? -eq 0 ]]; then
        log "[+] Ngrok installed successfully"
    else
        log "[!] Ngrok has not been installed due an error. Please try again later"
        exit 1
    fi
}

update_os
banner
dependencies