# DetectCanaryTokens
Detect Canary Tokens is a CLI script designed to search through files in a specified directory for potential canary tokens (URLs typically used as honeypots to detect unauthorized access). The script reads through each file in the directory and its subdirectories, identifies URLs, and logs them into a designated text file.

## Note

* This script natively runs within a Unix/Linux enviorment. For Windows enviorments, users must run this script within a Virtual Machine (e.g., VMWare, Virtual Box, Hyper-V, etc.), Windows Subsystem for Linux (WSL), or applications like Gitbash or Cygwin.

## Prerequsities
* Make sure [git](https://git-scm.com/downloads) is downloaded, as it's needed to clone this repository.

## Usage

**1. Installation**

 - Clone this repository with: ```git clone https://github.com/Hokeey/DetectCanaryTokens```
 
 - CD into DetectCanaryTokens
 
 - Make the bash script executable: ```chmod +x find_canary_tokens.sh```
 
 - Run script: ```./find_canary_tokens.sh /path/to/directory output.txt ```
Note: The text file name can be anything. Just keep in mind, if the script is executed twice with the same text name, the second execution of the script will replace the logged results of the previous execution. 

**2. Interpret Results**

Each execution of the script will log the extracted URLs within XML files in a separate text file, and once logged you can search through the text file to find any suspious URLs. To find instances of logged URL connections to canary tokens within the text file ```Control + F``` on Windows/Linux or ```Command + F``` for OS X.

# Script Preview 

![cts_output](https://github.com/user-attachments/assets/8a52c845-f876-49dc-8b35-bc2d58c85a9a)

### Disclaimer

This script is intended for educational and security testing purposes only. Utilize it responsibly and in compliance with applicable laws and regulations. And remember... ***DON'T DO CRIME :)***
    










 
