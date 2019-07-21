#!/usr/bin/env bash
set -euo pipefail 
IFS=$'\n\t'
shopt -s nullglob 
shopt -s nocaseglob

# move script into place
sudo mv tune_sshd.sh /Library/Scripts/tune_sshd.sh
sudo chmod +x /Library/Scripts/tune_sshd.sh

# move launchd plist into place
sudo mv tune_sshd.plist /Library/LaunchDaemons/tune_sshd.plist

sudo tune_sshd.sh

