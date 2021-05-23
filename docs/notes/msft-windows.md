# Windows
#### Get Last Reboot Time
```PowerShell
Invoke-Command -ComputerName cn8011swaddc01 -ScriptBlock {Get-WmiObject -class Win32_OperatingSystem | Select-Object  __SERVER,@{label='LastBootUpTime';expression={$_.ConvertToDateTime($_.LastBootUpTime)}}|ft}
```
#### Add Domain User To Local Administrators Group
```PowerShell
Invoke-Command -ComputerName MBP-DEV.LogiStellar.internal -scriptblock {net localgroup Administrators /add "LogiStellar\tclyu"}
Invoke-Command -ComputerName MBP-DEV.LogiStellar.internal -scriptblock {Add-LocalGroupMember -Group Administrators -Member "LogiStellar\tclyu"}
```
```cmd
$computer = "computerName"
$domainUser = "domainName/samAccountName"
$group = "administrators"
$groupObj = [adsi]"WinNT://$computer/$group,group"
$userObj = [adsi]"WinNT://$domainUser,user"
$groupObj.add($userObj.Path)
```
#### Copy dump files
```CMD
robocopy \\serverFqdn\C$\Windows\MiniDump c:\users\tclv_adadmin\documents\minidumps\serverFqdn
```
#### Office Document Icon Mssing After Uninstall WPS
```CMD
rem Restore MS Office default icon modified by WPS
 
:: Change path to real path of target computer
set officepath=C:\Program Files\Microsoft Office\Office16\
 
:: Fix Word icon
reg add "HKCR\Word.Document.8\DefaultIcon" /ve /t REG_SZ /d "%officepath%WORDICON.EXE,1"
reg delete "HKCR\Word.Document.8\DefaultIcon" /v .ksobak
reg add "HKCR\Word.Document.12\DefaultIcon" /ve /t REG_SZ /d "%officepath%WORDICON.EXE,13"
reg delete "HKCR\Word.Document.12\DefaultIcon" /v .ksobak
reg add "HKCR\Excel.Sheet.8\DefaultIcon" /ve /t REG_SZ /d "%officepath%XLICONS.EXE,28"
reg delete "HKCR\Excel.Sheet.8\DefaultIcon" /v .ksobak
reg add "HKCR\Excel.Sheet.12\DefaultIcon" /ve /t REG_SZ /d "%officepath%XLICONS.EXE,1"
reg delete "HKCR\Excel.Sheet.12\DefaultIcon" /v .ksobak
reg add "HKCR\PowerPoint.Show.8\DefaultIcon" /ve /t REG_SZ /d "%officepath%PPTICO.EXE,17"
reg delete "HKCR\PowerPoint.Show.8\DefaultIcon" /v .ksobak
reg add "HKCR\PowerPoint.Show.12\DefaultIcon" /ve /t REG_SZ /d "%officepath%PPTICO.EXE,10"
reg delete "HKCR\PowerPoint.Show.12\DefaultIcon" /v .ksobak

:: Delete IconCache.db
taskkill /f /im explorer.exe
CD /d %userprofile%\AppData\Local
DEL IconCache.db /a
```
#### Install MSI package
Silently install MSI package
```cmd
msiexec.exe /I \\FileShare\filename.msi /quiet 
```
```PowerShell
Start-Process -FilePath msiexec.exe -Wait -ArgumentList "/I \\FileShare\filename.msi /qn"
```
```PowerShell
$msiFile
$logTime = Get-Date -Format yyyyMMddTHHmmss
$logFile = '{0}-{1}.log' -f $msiFile.fullname,$logTime
$MSIArguments = @(
    "/i"
    ('"{0}"' -f $file.fullname)
    "/qn"
    "/norestart"
    "/L*v"
    $logFile
)
Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow
```
#### Run program without admin privilege
Force a program to run without admin privilege.
##### Methods

1. Save this to a bat file. Drag executable to this bat file to run as non-priviledged account.
```CMD
cmd /min /C "set __COMPAT_LAYER=RUNASINVOKER && start "" %1"
```
2. One line
```CMD
"C:\Windows\System32\cmd" /min /C "set __COMPAT_LAYER=RUNASINVOKER && start "" %1 "c:\users\Public\desktop\ZPST for RY.lnk"
```
3. Alternatively, create shortcut on Public Desktop
```PowerShell
Set-Content "C:\Users\Public\Desktop\RunAsNormalUser.bat" 'cmd /min /C "set __COMPAT_LAYER=RUNASINVOKER && start "" %1"'
```
#### Create shortcut
```PowerShell
function New-Shortcut {
    param ( [string]$SourceLnk, [string]$DestinationPath )

        $WshShell = New-Object -comObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut($SourceLnk)
        $Shortcut.TargetPath = $DestinationPath
        $Shortcut.Save()
    }

New-Shortcut "\\Where_This_Shortcut_is_Placed\Shortcut_Name.lnk" "\\Destination_Of_this_shortcut\app.exe"
```

#### Install All RSAT Features
```PowerShell
$items = Get-WindowsCapability -Online | Where-Object {$_.Name -like "Rsat*" -AND $_.State -eq "NotPresent"}
if ($items -ne $null) {
    foreach ($Item in $items) {
        $rsatItem = $Item.Name
        Write-Host "Adding $rsatItem to Windows"
        try {
            Add-WindowsCapability -Online -Name $rsatItem
        }
        catch [System.Exception] {
            Write-Host "Failed to add $rsatItem to Windows"
            Write-Host "$($_.Exception.Message)"
        }
    }
}
else {
    Write-Host "All RSAT features seems to be installed already"
}
```
#### Query and kick user remotely
```BAT
query user /server:SERVERNAME
logoff SESSIONID /server:SERVERNAME
```
#### Export EFS private key
https://docs.microsoft.com/en-us/powershell/module/pkiclient/export-pfxcertificate?view=win10-ps
```PowerShell
$filePath = "$env:USERPROFILE\Documents\efs_${env:USERDOMAIN}_${env:USERNAME}.pfx" # path of exported file
$password = Read-Host -AsSecureString "Provide password..."
Get-ChildItem -Path Cert:\CurrentUser\My | Export-PfxCertificate -FilePath $filePath -Password $password
```
#### Import EFS private key
https://docs.microsoft.com/en-us/powershell/module/pkiclient/import-pfxcertificate?view=win10-ps
```PowerShell

```
#### Enable RDP
```
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
```
#### Disable Firewall
This command overrides GPO settings, for a moment.
```
Set-NetFirewallProfile   -Name domain,private,public -Enabled False
```
#### Export all drivers to folder
https://docs.microsoft.com/en-us/windows-hardware/drivers/devtest/pnputil
```cmd
PnPUtil /export-driver * c:\mytemp\driverExport
```
