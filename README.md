# BashBunny

BashBunny is the last hardware hacking tool created for pentesting audits. Do you have physical access to a computer? Nice! Use BLACKBOX for get a fantastic shell with privileges in seconds over internet!

## How works
Bash Bunny is composed by two parts:
* Software tool (BashBunny)
* Hardware tool (BlackBox) - Arduino Leonardo based on the ATmega32u4 microcontroller.

### About software tool
![Captura de pantalla 2023-02-09 212254](https://user-images.githubusercontent.com/76668073/217928660-d29f4840-a5dc-4335-800b-d5f131e0d435.png)


You will need this software for automate the process. After download this tool

- Give permissions to the main file with:

`chmod +x ./main.sh`

- Execute (without sudo) the file:

`./main.sh`

- Install dependencies
- Load your ngrok token adding the token in the `credentials.txt` file . Register in https://ngrok.com/ for get your token.
- Finally, configure your blackbox, this process is completely automatic. This will configure the malicious file which will be downloaded by the target machine once the arduino is connected to the target opening a HTTP server in the attacker side. And compiling all the necessary code for disable UAC, Firewall and any other Windows Defense for execute our malicious code and get RCE (Remote Code Execution) with privileges.

### About hardware tool
![unnamed](https://user-images.githubusercontent.com/76668073/217931773-d7f841bc-e160-4b85-857d-9489071b15c0.jpg)

The hardware tool used is a simple Arduino Leonardo based on the ATmega32u4 microcontroller, this microcontroller is compatible HID (Human Interface Device). Refers to a type of user interface for computers that interact directly, taking inputs from humans, and can deliver an output to humans.

This means that blackbox allows us to put commands really fast, executing malicious commands previuosly configured with our software tool in the target machine.

## To Do
- ~~Improve CLI Interface (more friendly)~~
- ~~Improve the output received by the user~~
- ~~Delete useless code~~
- ~~Optimize main code deleting the duplicate code~~
- Improve current RCE to RCE Stealth Mode (https://www.elladodelmal.com/2017/07/arducky-un-rubber-ducky-hecho-sobre.html)
- Add new payloads and possibilities
- Make a video of how works
