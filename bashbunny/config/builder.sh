#!/bin/bash

# Sourcing the function banner, update_os and docker_installation inside main_functions.sh
source main_functions.sh

if [[ $EUID -ne 0 ]]; then
    echo "[!] This script must to be run as root" 1>&2
    exit 1
else
    # Call functions
    banner
    update_os
    dependencies
fi