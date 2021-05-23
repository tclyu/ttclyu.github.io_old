# Chocolatey
## Official Site
https://chocolatey.org
### Install
```PowerShell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```
### Install Packages
```
choco {{packageName}} -y
choco {packages} -y --exit-when-reboot-detected
```
### Choco Packages
#### Common
```
7zip firefox googlechrome notepadplusplus winrar
```
#### Development
```
choco install -y beyondcompare filezilla nirlauncher powershell-core putty sql-server-management-studio sysinternals vscode wireshark winscp wsus-offline-update
```
#### Productivity
```
microsoft-teams paint.net youtube-dl treesizefree goodsync
```
```
wireshark
nirlauncher
notepadplusplus
googlechrome
firefox
7zip
openssh
python3
autohotkey
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
=======
```
#### Depreciated
```
microsoft-message-analyzer # https://docs.microsoft.com/en-us/openspecs/blog/ms-winintbloglp/dd98b93c-0a75-4eb0-b92e-e760c502394f
```
