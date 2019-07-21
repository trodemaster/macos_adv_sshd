#!/usr/bin/env bash
set -euo pipefail 
IFS=$'\n\t'
shopt -s nullglob 
shopt -s nocaseglob

# This script tunes the sshd_conf file to disable password and root logins. 

# disable root login. Not really needed on macOS
sudo sed -i '' 's/#PermitRootLogin.*/PermitRootLogin no/g' /etc/ssh/sshd_config
sudo sed -i '' 's/^PermitRootLogin.*/PermitRootLogin no/g' /etc/ssh/sshd_config

# disable ChallengeResponse
sudo sed -i '' 's/#ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config
sudo sed -i '' 's/^ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config

# disable PasswordAuth
sudo sed -i '' 's/#PasswordAuthentication.*/PasswordAuthentication no/g' /etc/ssh/sshd_config
sudo sed -i '' 's/^PasswordAuthentication.*/PasswordAuthentication no/g' /etc/ssh/sshd_config

# create host specific path
SSH_INCLUDE="/etc/ssh/sshd_config_$(hostname -s)"

# setup the extra config file
if [[ ! -e $SSH_INCLUDE ]]; then
  echo "Creating host specific sshd config file $SSH_INCLUDE"
  sudo touch $SSH_INCLUDE
  sudo chown root:wheel $SSH_INCLUDE
  sudo chmod 600 $SSH_INCLUDE
fi

# include extra config file that sshd can import if it's a new enough version
if [[ -e $SSH_INCLUDE ]]; then
  sudo sed -i '' '/Include/d' /etc/ssh/sshd_config
  echo "Include $SSH_INCLUDE" | sudo tee -a /etc/ssh/sshd_config
fi

# Restart sshd to pickup config changes
launchctl stop /System/Library/LaunchDaemons/ssh.plist || true
launchctl start /System/Library/LaunchDaemons/ssh.plist || true

# Log a timestamp for this script run
echo "tune_sshd ran $(date)"

exit 0