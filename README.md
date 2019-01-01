# macos_adv_sshd
Advanced sshd configuration for built in sshd server. Installing this script and launchd plist will maintain some key settings in /etc/ssh/sshd_config on macOS. Apple likes to overwrite this file with system updates. This setup will update the key parts of the config file at every boot to make sure password based login is disabled. Additionally it adds an include directive to /etc/ssh/sshd_config_$HOSTNAME so you can add additional configuration that persists updates. 

### Move files into place
```
sudo cp tune_sshd.plist /Library/LaunchDaemons/
sudo cp tune_sshd.sh /Library/Scripts/
```

### Run the script
```
sudo /Library/Scripts/tune_sshd.sh
```

### Load the launchd plist
```
sudo launchctl load -w /Library/LaunchDaemons/tune_sshd.plist
``` 

### Confirm script ran at reboot
Reboot your system and check the contents of the log file for a datestamp. 
```
cat /tmp/tune_sshd.stdout
```