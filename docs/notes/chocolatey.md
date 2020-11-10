# Chocolatey
## Official Site
https://chocolatey.org
### Install
```PowerShell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```
### Install Packages
choco {{packageName}} -y
### Choco Packages
```
wireshark
nirlauncher
notepadplusplus
microsoft-message-analyzer
googlechrome
firefox
7zip
openssh
winrar
python3
putty
autohotkey
sysinternals
winlogbeat
filezilla
microsoft-teams
paint.net
vscode
treesizefree
sql-server-management-studio
winscp
youtube-dl
wsus-offline-update
powershell-core
dependencywalker
```
#### Production Packages
```
choco install -y notepadplusplus googlechrome winrar treesizefree youtube-dl internet-download-manager windscribe microsoft-edge teamviewer

```
#### Development Packages
```
choco install -y 
```
#### Test Packages
```
choco install -y dependencywalker
```
