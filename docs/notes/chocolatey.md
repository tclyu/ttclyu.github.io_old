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
#### Development
```
choco install -y 7zip beyondcompare filezilla firefox googlechrome microsoft-message-analyzer nirlauncher notepadplusplus powershell-core putty sql-server-management-studio sysinternals treesizefree vscode wireshark winrar winscp wsus-offline-update
```
```
openssh
python3
autohotkey
winlogbeat
microsoft-teams
paint.net
youtube-dl
```
