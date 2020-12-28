# AD Directory Services
#### Events
https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/plan/appendix-l--events-to-monitor
#### Set Thumbnail Photo
```PowerShell
$UserIdentity
$AvatarFilePath # Path of the JPG file
Set-ADUser $UserIdentity -Replace @{thumbnailPhoto=([byte[]](Get-Content $AvatarFilePath -Encoding byte))}
```
#### Get ADUser By CanonicalName
```PowerShell
$CanonicalName

Get-ADUser -Properties CanonicalName -Filter *|Where-Object {$_.CanonicalName -eq $CanonicalName}
```
#### Extend Password Expiry
Reset password expiring date to now for enabled users of specific OU who's password is expiring in # of days.
```PowerShell
$Days = 14 # Expiring in # of days
$SearchBase # OU to search

$users = Get-ADUser -SearchBase $SearchBase -Filter {Enabled -eq $true} -Properties pwdLastSet |Select sAMAccountName, @{n='pwdLastSet';e={[DateTime]::FromFileTime($_.pwdLastSet)}} |Where-object {$_.pwdlastset -lt (Get-Date).AddDays(-$Days)} 
foreach ($user in $users) {
    $userObject = Get-ADUser $user.sAMAccountName -Properties pwdLastSet 
    $userObject.pwdLastSet = 0 # Password must be changed at next logon
    Set-ADUser -Instance $userObject 
    $userObject.pwdLastSet = -1 # Password just have been reset
    Set-ADUser -Instance $userObject 
}
```
#### Convert SAMAccountName and UPN to Lower Case
```PowerShell
$SearchBase

Get-ADUser -SearchBase $SearchBase -Filter {Enabled -eq $true}|ForEach-Object {
    Set-ADUser -Identity $_ -SamAccountName $_.SamAccountName.ToLower()
    Set-ADUser -Identity $_ -UserPrincipalName $_.UserPrincipalName.ToLower()
}
```
#### Get ActiveDirectory Schema
```PowerShell
Get-ADObject -SearchBase ((Get-ADRootDSE).schemaNamingContext) -SearchScope OneLevel -Filter * -Property objectClass, name, whenChanged, whenCreated, attributeID,IsIndexed,IsSingleValued `
    | Select-Object objectClass, attributeID, name, whenCreated, whenChanged, @{name="event";expression={($_.whenCreated).Date.ToString("yyyy-MM-dd")}} `
    | Sort-Object event, objectClass, name
```
#### List Computers Not Logged On In a Specific Duration
```PowerShell
$DaysInactive = 180

Get-ADComputer -Filter {LastLogonTimeStamp -lt (Get-Date).Adddays(-($DaysInactive))} -Properties LastLogonTimeStamp |Select-Object Name,@{Name="TimeStamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}} | export-csv <Path_To_Csv_File> -NoTypeInformation
```

#### Get Lock Events
```PowerShell

$ErrorActionPreference = "SilentlyContinue"
Clear-Host
$User = Read-Host -Prompt "Please enter a user name"
#Locate the PDC
$PDC = (Get-ADDomainController -Discover -Service PrimaryDC).Name
#Locate all DCs
$DCs = (Get-ADDomainController -Filter *).Name #| Select-Object name
foreach ($DC in $DCs) {
Write-Host -ForegroundColor Green "Checking events on $dc for User: $user"
if ($DC -eq $PDC) {
    Write-Host -ForegroundColor Green "$DC is the PDC"
    }
Get-WinEvent -ComputerName $DC -Logname Security -FilterXPath "*[System[EventID=4740 or EventID=4625 or EventID=4770 or EventID=4771 and TimeCreated[timediff(@SystemTime) <= 3600000]] and EventData[Data[@Name='TargetUserName']='$User']]" | Select-Object TimeCreated,@{Name='User Name';Expression={$_.Properties[0].Value}},@{Name='Source Host';Expression={$_.Properties[1].Value}} -ErrorAction SilentlyContinue
}
```
### Well Known ADObjects
```PowerShell
$items = (Get-ADObject -filter 'ObjectClass -eq "domain"' -Properties wellKnownObjects).wellKnownObjects

$items | ForEach-Object {
    if ($_ -match '^B:32:A9D1CA15768811D1ADED00C04FD8D5CD:(.*)$')
    {
        $usersOU = '{0}' -f $matches[1]
    }
    elseif ($_ -match '^B:32:AA312825768811D1ADED00C04FD8D5CD:(.*)$')
    {
        $computersOU = '{0}' -f $matches[1]
    }
}

```
###### Result
```
B:32:6227F0AF1FC2410D8E3BB10615BB5B0F:CN=NTDS Quotas,DC=LogiStellar,DC=internal
B:32:F4BE92A4C777485E878E9421D53087DB:CN=Microsoft,CN=Program Data,DC=LogiStellar,DC=internal
B:32:09460C08AE1E4A4EA0F64AEE7DAA1E5A:CN=Program Data,DC=LogiStellar,DC=internal
B:32:22B70C67D56E4EFB91E9300FCA3DC1AA:CN=ForeignSecurityPrincipals,DC=LogiStellar,DC=internal
B:32:18E2EA80684F11D2B9AA00C04F79F805:CN=Deleted Objects,DC=LogiStellar,DC=internal
B:32:2FBAC1870ADE11D297C400C04FD8D5CD:CN=Infrastructure,DC=LogiStellar,DC=internal
B:32:AB8153B7768811D1ADED00C04FD8D5CD:CN=LostAndFound,DC=LogiStellar,DC=internal
B:32:AB1D30F3768811D1ADED00C04FD8D5CD:CN=System,DC=LogiStellar,DC=internal
B:32:A361B2FFFFD211D1AA4B00C04FD7D83A:OU=Domain Controllers,DC=LogiStellar,DC=internal
B:32:AA312825768811D1ADED00C04FD8D5CD:CN=Computers,DC=LogiStellar,DC=internal
B:32:A9D1CA15768811D1ADED00C04FD8D5CD:CN=Users,DC=LogiStellar,DC=internal
```
### Prepare AD
```
$domainRootDN = (Get-ADDomain).DistinguishedName

$deviceOuName = "Devices"
$principalOuName = "Principals"
$corporationOuName = "Corporation"

New-ADOrganizationalUnit $deviceOuName -Path $domainRootDN
New-ADOrganizationalUnit $principalOuName -Path $domainRootDN
New-ADOrganizationalUnit $corporationOuName -Path $domainRootDN
```
#### Search string in GPO
```powershell
# Search for a string in all GPOs in a domain. Returns the DisplayName of the GPO.
$stringToSearch # string to search
$domainName = $env:USERDNSDOMAIN # domain to search

Import-Module GroupPolicy
$allGposInDomain = Get-GPO -All -Domain $DomainName
foreach ($gpo in $allGposInDomain) {
    $report = Get-GPOReport -Guid $gpo.Id -ReportType Xml
    if ($report -match $stringToSearch) {
        write-host "String $stringToSearch found in: $($gpo.DisplayName)."
    }
    else {
        Write-Host "No match found in: $($gpo.DisplayName)"
    }
}
```
