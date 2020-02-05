# Advanced sshd configuration for the built in OpenSSH server on macOS
Installing this script and launchd plist will maintain some key settings in /etc/ssh/sshd_config on macOS. Apple likes to overwrite this file with system updates. This setup will update the key parts of the config file at every boot to make sure _password based login is disabled_. 


### Install the script
Take a minute to review the contents of the install script to see what's going on then run it.
```
./install.sh

```
### Adjust the actual settings
The [tune_sshd.sh](tune_sshd.sh) script contains a few sed commands to rewrite the /etc/ssh/sshd_config settins. Augment this as needed... 

