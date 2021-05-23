# Homebrew
## Official Site
https://brew.sh
## Install on MacOS
```bash
rm -fr $(brew --repo homebrew/core)  # because you can't `brew untap homebrew/core`
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```
#### How To Fix Permission Issue?
https://stackoverflow.com/questions/44195496/homebrew-could-not-symlink-usr-local-share-man-man7-is-not-writable
```bash
cd /usr/local && sudo chown -R $(whoami) bin etc include lib sbin share var Frameworks
```
## Brews
```Bash
docker
YouTube-dl
htop
python
azure-cil
openconnect
```
## Casks
```Bash
docker
visual-studio-code
google-chrome
firefox
postman
powershell
db-browser-for-sqlite
wireshark
windscribe
parallels
iina
vmware-fusion
vmware-horizon-client
PluralSight
android-studio
android-platform-tools
dotnet-sdk
electron
shadowsocksx-ng
discord
alfred
microsoft-teams
teamviewer
pdf-expert
disk-drill
imazing
intellij-idea
epic-games
cisco-jabber
tencent-meeting
# openconnect-gui #has security issue.
splashtop-personal
downie
little-snitch
goodsync
voov-meeting
```
