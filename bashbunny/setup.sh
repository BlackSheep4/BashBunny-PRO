#!/bin/bash

# Sourcing the function banner, update_os and docker_installation inside main.sh
source $HOME/BashBunny/bashbunny/config/main.sh

if [[ $EUID -ne 0 ]]; then
    echo "[!] This script must to be run as root" 1>&2
    exit 1
else
    # Call functions
    
    echo "FUNCION BANNER TERMINADA"
    update_os
    echo "FUNCION UPDATE_OS TERMINADA"
    docker_installation
    echo "FUNCION DOCKER TERMINADA"
fi