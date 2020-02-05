#!/usr/bin/env bash
set -euo pipefail 
IFS=$'\n\t'
shopt -s nullglob 
shopt -s nocaseglob

# create /usr/local/bin if it doesn't exist
if ! [[ -d /usr/local/bin ]]; then
    sudo mkdir -p /usr/local/bin
fi

# move script into place
sudo cp tune_sshd.sh /usr/local/bin/tune_sshd.sh
sudo chmod +x /usr/local/bin/tune_sshd.sh

# move launchd plist into place
sudo cp tune_sshd.plist /Library/LaunchDaemons/tune_sshd.plist

# Stop start the new launchd item to load it
launchctl stop /Library/LaunchDaemons/tune_sshd.plist || true
launchctl start /Library/LaunchDaemons/tune_sshd.plist || true

# run the script
sudo /usr/local/bin/tune_sshd.sh

