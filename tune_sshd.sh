#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# This script tunes the sshd_conf file to disable password and root logins. 

# handle sed differences GNU vs BSD
SEDOPT='-i.bak'
UNAME=$(uname)
if [[ $UNAME == "Linux" ]]; then
  SEDOPT='-i'
fi  

# disable root login. Not really needed on macOS
sed $SEDOPT 's/#PermitRootLogin.*/PermitRootLogin no/g' /etc/ssh/sshd_config
sed $SEDOPT 's/^PermitRootLogin.*/PermitRootLogin no/g' /etc/ssh/sshd_config

# disable ChallengeResponse
sed $SEDOPT 's/#ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config
sed $SEDOPT 's/^ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config

# disable PasswordAuth
sed $SEDOPT 's/#PasswordAuthentication.*/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed $SEDOPT 's/^PasswordAuthentication.*/PasswordAuthentication no/g' /etc/ssh/sshd_config

# include extra config file that sshd can import if it's a new enough version
SSH_INCLUDE="/etc/ssh/sshd_config_$(hostname -s)"
if [[ -e $SSH_INCLUDE ]]; then
  sed $SEDOPT '/Include/d' /etc/ssh/sshd_config
  echo "Include $SSH_INCLUDE" >> /etc/ssh/sshd_config
fi

# Restart sshd to pickup config changes
if [[ $UNAME == "Linux" ]]; then
  if ! $(service sshd restart); then
   service ssh restart
  fi
elif [[ $UNAME == "Darwin" ]]; then
  launchctl stop /System/Library/LaunchDaemons/ssh.plist || true
  launchctl start /System/Library/LaunchDaemons/ssh.plist || true
fi

# Log a timestamp for this script run
echo "tune_sshd ran $(date)"

exit 0