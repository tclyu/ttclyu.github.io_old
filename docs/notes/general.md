
# AD Certificate Services

# Office 365
### Show Update dialog of Office 365 without launching the application
```
"C:\Program Files\Common Files\microsoft shared\ClickToRun\OfficeC2RClient.exe" /update user
```
# PowerShell
### Common Parameters
#### ErrorAction
Unlike SilentlyContinue, Ignore doesn't add the error message to the $Error automatic variable.
###### Reference
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_commonparameters?view=powershell-7
### Envrionment Variables
```PowerShell
Get-Item -Path Env:* # List all EnvrionmentVariables
$ENV:COMPUTERNAME # Get ComputerName
```
### Create ArrayList
```PowerShell
$result = [System.Collections.ArrayList]@()
$result.Add($instance) | Out-Null
```

### Download and Execute PS1 file
```PowerShell
Invoke-Command -ComputerName cn8011swopsvt -ScriptBlock {iex ((New-Object System.Net.WebClient).DownloadString('http://mirrors.royole.com/openssh/Deploy-OpenSSH.ps1'))}
```
### Create Directory In Temporary Folder With Random Guid As Name
```PowerShell
$parentPath = [System.IO.Path]::GetTempPath()
[string] $path = [System.Guid]::NewGuid()
New-Item -ItemType Directory -Path (Join-Path $parentPath $path)
```
### Convert current time to UTC
```PowerShell
(Get-Date).ToUniversalTime()
```
### List Processes of Remote Computer
```PowerShell
Get-WmiObject -Namespace "root\cimv2" -Class Win32_Process -Impersonation 3 -Credential `
ry\tclvadadmin -ComputerName CN8011DW01825
```
### Get Services From All Computers
```PowerShell
$computerlist = Get-ADComputer -Filter {OperatingSystem -like "Windows Server*" } | Select-Object -ExpandProperty Name
$csvFileName = "c:\Users\tclv_adadmin\Documents\AllComputers.ry.csv"
$results = @()
if (Test-Path $csvFileName)
{
    $results += Import-Csv -Path $csvFileName
}
foreach ($computer in $computerlist) {
    if((Test-Connection -Cn $computer -BufferSize 16 -Count 1 -ea 0 -quiet))
    {
        foreach ($service in Get-Service -ComputerName $computer) {
            $details= @{
                ComputerName=$computer
                Name=$service.Name
                DisplayName=$service.DisplayName
                StartType=$service.StartType
                Status=$service.Status
            }
            $results += New-Object PSObject -Property $details  

        }
    }
}
$results | export-csv -Path $csvFileName -Encoding UTF8 -NoTypeInformation
```
### Ping host async
```PowerShell
$ArrayOfHosts = @() # List of IP addresses / hosts
$Tasks = $ArrayOfHosts | % {
    [System.Net.NetworkInformation.Ping]::new().SendPingAsync($_)
}
[Threading.Tasks.Task]::WaitAll($Tasks)
$Tasks.Result
```
###### More Information
https://www.reddit.com/r/PowerShell/comments/9us77o/convert_a_string_of_an_ip_range_so_that/
# Vmware PowerCLI
### Get Average CPU, Memory, Network and Disk usage
Calculates the average CPU, Memory, Network and Disk usage for powered on virtual machines over the last 30 days, 5 minutes interval.
```PowerShell
Get-VM | Where {$_.PowerState -eq "PoweredOn"} | Select Name, Host, NumCpu, MemoryMB, `
@{N="CPU Usage (Average), Mhz" ; E={[Math]::Round((($_ | Get-Stat -Stat cpu.usagemhz.average -Start (Get-Date).AddDays(-30) -IntervalMins 5 | Measure-Object Value -Average).Average),2)}}, `
@{N="Memory Usage (Average), %" ; E={[Math]::Round((($_ | Get-Stat -Stat mem.usage.average -Start (Get-Date).AddDays(-30) -IntervalMins 5 | Measure-Object Value -Average).Average),2)}} , `
@{N="Network Usage (Average), KBps" ; E={[Math]::Round((($_ | Get-Stat -Stat net.usage.average -Start (Get-Date).AddDays(-30) -IntervalMins 5 | Measure-Object Value -Average).Average),2)}} , `
@{N="Disk Usage (Average), KBps" ; E={[Math]::Round((($_ | Get-Stat -Stat disk.usage.average -Start (Get-Date).AddDays(-30) -IntervalMins 5 | Measure-Object Value -Average).Average),2)}} |`
Export-Csv -Path <Path_To_Csv_File>
```
###### Refrence
http://vstrong.info/2014/11/18/powercli-average-cpu-memory-network-and-disk-usage/
### Get Name and IP of all VMs
```PowerShell
Get-VM | Select name,@{N=”IP Address”;E={@($_.guest.IPAddress[0])}} | export-csv –path <Path_To_Csv_File>
```
# Windows DHCP
# SQL Server
### Execute query
```PowerShell
$Query = SELECT Oid FROM UserItem
Invoke-Sqlcmd -ServerInstance 'CN8011SWOPSVT\MSSQLSERVER,1433' -Query $Query -Username 'sa' -Password <Password> -Database 'TuochenLyu.OpsVaultLiteXPO'
```


# Windows Admin Center
https://docs.microsoft.com/en-us/windows-server/manage/windows-admin-center/deploy/install

Run the following command to install Windows Admin Center and automatically generate a self-signed certificate:
```BAT
msiexec /i <WindowsAdminCenterInstallerName>.msi /qn /L*v log.txt SME_PORT=<port> SSL_CERTIFICATE_OPTION=generate
```
Run the following command to install Windows Admin Center with an existing certificate:
```
msiexec /i <WindowsAdminCenterInstallerName>.msi /qn /L*v log.txt SME_PORT=<port> SME_THUMBPRINT=<thumbprint> SSL_CERTIFICATE_OPTION=installed
```
#### VM naming on workstation
{platform}-{system}-{version/usage}
```
PRL-WD10-PROD
Parallels, Windows 10, for production senario.
```
{domain-site-machineName}
```
LS-MBPFSN-MXS
LogiStellar domain, hosted by Fusion on MBP, ExcahngeServer
```
Gold Images
```
GOLD-WS19DCCORE-2004
gold image, Windows Server DataCenter Core, 2004
```
#### Vmware Workstation: Run PowerShell Script From Local Share
```PowerShell
$ScriptPath
& "\\vmware-host\shared folders\$ScriptPath"
```
```
