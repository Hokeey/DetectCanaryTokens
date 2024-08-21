# DetectCanaryTokens
Detect Canary Tokens is a CLI script designed to search through files in a specified directory for potential canary tokens (URLs typically used as honeypots to detect unauthorized access). The script reads through each file in the directory and its subdirectories, identifies URLs, and logs them into a designated text file.

## Note

* This script natively runs within a Unix/Linux enviorment. For Windows enviorments, users must run this script within a Virtual Machine (e.g., VMWare, Virtual Box, Hyper-V, etc.), Windows Subsystem for Linux (WSL), or applications like Gitbash or Cygwin.

## Prerequsities
* Make sure [git](https://git-scm.com/downloads) is downloaded, as it's needed to clone this repository.

## Installation and usage

 1. Clone this repository with: ```git clone https://github.com/Hokeey/DetectCanaryTokens```
 
 2. CD into DetectCanaryTokens
 
 3. Make the bash script executable: ```chmod +x find_canary_tokens.sh```
 
 4. Run script: ```./find_canary_tokens.sh /path/to/directory output.txt ```  
    










 
