#!/bin/bash

# Global variables
metasploit_package='https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb'
ssh_path="$HOME/.ssh/id_rsa"
log_file="$HOME/BashBunny/bashbunny/logs/logs.log"

# Control the output
trap ctrl_c INT

function ctrl_c() {
    log "[!] Exiting..."
    exit 0
}

# Create a log file
function log() {
    local msg="$(date '+%Y-%m-%d %H:%M:%S') - $*"
    echo "$msg" | tee -a "$log_file"
}

# Prepare log file
log "[+] Checking if log file exists..."
if [ -f "$log_file" ]; then
    log "[+] $log_file found. No need to create a new file."
else
    mkdir -p "$(dirname "$log_file")" # Ensures the directory for the log file exists
    touch "$log_file"
    chmod 664 "$log_file"
    log "[+] Log file created at $log_file"
fi

# Show banner
function banner() {
    clear
    source src/banner.sh
}

function update_os() {
    # Update the system
    log "[+] Updating the system. Be patient"
    apt update -y >> "$log_file" 2>&1

    if [[ $? -eq 0 ]]; then
        log "[+] System updated successfully"
    else
        log "[!] System has not been updated due an error. Please check the log for details."
        exit 1
    fi

    # Upgrade the system
    log "[+] Upgrading the system. Be patient"
    apt upgrade -y >> "$log_file" 2>&1
    if [[ $? -eq 0 ]]; then
        log "[+] System upgrade completed successfully."
    else
        log "[!] System has not been updated due an error. Please check the log for details."
        exit 1
    fi
}

# Install all dependencies
function dependencies() {
    log "[+] Installing dependencies. Be patient"
    
    # Metasploit
    log "[+] Installing Metasploit"
    curl -o msfinstall $metasploit_package >> "$log_file" 2>&1 && chmod 755 msfinstall >> "$log_file" 2>&1

    if [[ $? -eq 0 ]]; then
        log "[+] Metasploit installed successfully"
    else
        log "[!] Metasploit has not been installed due an error. Please check the log for details."
        exit 1
    fi

    # Git
    log "[+] Installing git"
    apt install git -y >> "$log_file" 2>&1

    if [[ $? -eq 0 ]]; then
        log "[+] Git installed successfully"
    else
        log "[!] Git has not been installed due an error. Please check the log for details."
        exit 1
    fi

    # OpenSSH
    log "[+] Installing OpenSSH"
    apt install ssh -y >> "$log_file" 2>&1

    if [[ $? -eq 0 ]]; then
        log "[+] SSH installed successfully"
        log "[+] Generating keys..."
        ssh-keygen -t rsa -b 2048 -f "$ssh_path" -N "" >> "$log_file" 2>&1
        if [[ $? -eq 0 ]]; then
            log "[+] SSH Keys successfully generated in: $ssh_path"
        else
            log "[!] SSH Keys has not been created due an error. Please check the log for details."
            exit 1
        fi
    else
        log "[!] SSH has not been installed due an error. Please check the log for details."
        exit 1
    fi

    # Snap installation
    log "[+] Installing snap"
    apt install snapd -y >> "$log_file" 2>&1
    if [[ $? -eq 0 ]]; then
        log "[+] Snap installed successfully"
    else
        log "[!] Snap has not been installed due an error. Please check the log for details."
        exit 1
    fi

    # ngrok installation
    log "[+] Installing ngrok"
    snap install ngrok
    if [[ $? -eq 0 ]]; then
        log "[+] Ngrok installed successfully"
    else
        log "[!] Ngrok has not been installed due an error. Please check the log for details."
        exit 1
    fi
}

# Install docker
function docker_installation() {
    log "[+] Installing docker"
    which docker >> "$log_file" 2>&1

    if [[ $? -eq 0 ]]; then
        log "[+] Docker was already installed. Avoiding installation..."
    else
        curl -fsSL https://get.docker.com | sh >> "$log_file" 2>&1

        if [[ $? -eq 0 ]]; then
            docker --version >> "$log_file" 2>&1
            if [[ $? -eq 0 ]]; then
                log "[+] Docker installed successfully."
                log "[+] Adding user to Docker group..."
                sudo usermod -aG docker $USER >> "$log_file" 2>&1
                if [[ $? -eq 0 ]]; then
                    log "[+] User $USER has been added successfully to the Docker group."
                else
                    log "[!] Failed to add $USER to the Docker group. Please check the log for details."
                fi
            else
                log "[!] Docker has not been installed successfully. Please check the log for details."
            fi        
        else
            log "[!] Docker installation failed. Please check the log for details."
        fi
    fi
}

if grep -qa 'docker' /proc/1/cgroup; then
    echo "Estoy corriendo dentro de Docker."
else
    echo "No estoy corriendo dentro de Docker."
fi