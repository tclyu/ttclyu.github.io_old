# Vmware Fusion
## Installing Windows
#### How To Enter Audit Mode?
After system installation and before configuration language, press Fn + Shift + Control + F3 to enter audit mode.
#### How To Install Vmware Tools Silently?
Installs 64 bit binary, whithout reboot. Add all components except PerfMon.
```
setup64.exe /S /v “/qn REBOOT=R ADDLOCAL=ALL REMOVE=PerfMon”
```
## Installing Vmware ESXi
#### How To Press F11 during Installation?
F11 key is nested. Press Fn + Cmd + F11 instead.

## Install PowerCLI on Mac
```PowerShell
# Enter PowerShell
pwsh

# Install Vmware.PowerCLI module
Install-Module -Name Vmware.PowerCLI
```
