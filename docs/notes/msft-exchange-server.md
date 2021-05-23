# Microsoft Exchange Server
### Connect Exchange Server
#### If Management Tools Installed Locally and Use Current Credential
```cmd
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -noexit -command ". 'C:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1'; Connect-ExchangeServer -auto -ClientApplication:ManagementShell "
```
#### Connect Remote Management Tools
https://docs.microsoft.com/en-us/powershell/exchange/connect-to-exchange-servers-using-remote-powershell?view=exchange-ps

#### Establish Connection
```PowerShell
$UserCredential = Get-Credential
$Session = New-PSSession `
    -ConfigurationName Microsoft.Exchange `
    -ConnectionUri http://<ServerFQDN>/PowerShell/ ` # The ConnectionUri can only be http, not https.
    -Authentication Kerberos `
    -Credential $UserCredential
Import-PSSession $Session -DisableNameChecking
```
#### Remove Connection
Remember to remove session after operation is completed.
```PowerShell
Remove-PSSession $Session
```
### Configure Hierarchy Address Book
```PowerShell
New-DistributionGroup -Name HAB_EnterpriseDirectory -DisplayName "Enterprise Directory" -SamAccountName "HAB_EnterpriseDirectory" -IsHierarchicalGroup $true -OrganizationalUnit "OU=Exchange,OU=Domain-Principals,DC=LogiStellar,DC=internal"
Get-DistributionGroup HAB_EnterpriseDirectory|Set-Group -IsHierarchicalGroup $true
Set-OrganizationConfig -HierarchicalAddressBookRoot "HAB_EnterpriseDirectory"
```

### Removing an auto-mapped mailbox

```PowerShell
Add-MailboxPermission -Identity <Shared_Mailbox_Alias> -User <Owner_Mailbox_alias> -AccessRights FullAccess -InheritanceType All -Automapping $false
```
- This command removes the reference to the user with the Full Access permissions from the *msExchDelegateListLink* property of the additional mailbox.
- The additional mailboxes for a user are propagated via the *AlternateMailbox* attribute with AutoDiscover.
#### Reference
https://docs.microsoft.com/en-us/previous-versions/office/exchange-server-2010/hh529943(v=exchg.141)?redirectedfrom=MSDN
https://www.msoutlook.info/question/673
#### Remove Messages
Search and delete messages from target mailboxes.
```PowerShell
# Create a ComplianceSearch
New-ComplianceSearch -Name <Name_Of_The_Search> -ExchangeLocation all -ContentMatchQuery 'From:sender@logistellar.com AND To: recpipent@logistellar.com AND Sent>=5/19/2020 AND Sent<5/21/2020'
# Start the ComplianceSearch
Start-ComplianceSearch -Identity <Name_Of_The_Search>
# Get ComplianceSearch status
Get-ComplianceSearch -Identity <Name_Of_The_Search> |fl
# Purge messages
New-ComplianceSearchAction -SearchName <Name_Of_The_Search> -Purge -PurgeType SoftDelete
```
##### Note
User must be a member of *Discovery Management* group.
##### HardDelete Not Working
When running New-ComplianceSearchAction -Purge -PurgeType HardDelete does not work. I can't make it work. 
```
Cannot process argument transformation on parameter 'PurgeType'. Cannot convert value "HardDelete" to type "Microsoft.Exchange.Compliance.TaskDistributionCommon.ObjectModel.ComplianceDestroyType". Error: "Unable to match the identifier name HardDelete
to a valid enumerator name. Specify one of the following enumerator names and try again:
Unknown, SoftDelete"
    + CategoryInfo          : InvalidData: (:) [New-ComplianceSearchAction], ParameterBindin...mationException
    + FullyQualifiedErrorId : ParameterArgumentTransformationError,New-ComplianceSearchAction
    + PSComputerName        : MBP-MXS1.LogStellar.internal
```
#### Todo
Test on Exchange Online and Exchange Server 2019 later.
#### Modify TransportConfig
```PowerShell
# Run as admin first
Get-Transportconfig | ft Maxsendsize, Maxreceivesize 
Get-Receiveconnector | ft Name, Maxmessagesize
Get-Sendconnector | ft Name, Maxmessagesize
# Set target value
Set-Transportconfig -MaxReceiveSize 25MB -MaxSendSize 25MB
# After chekcing mail queue, restart service
Get-Service -ComputerName cn8011swexma01 -ServiceName MSExchangeTransport|Restart-Service
```
### Delete Mail From Mailbox
```PowerShell
Get-Mailbox -ResultSize unlimited | Search-Mailbox -SearchQuery '(subject:调休过期通知) AND (FROM:HCM.Notify@royole.com) AND (sent>=10/01/2019) AND (sent<=10/02/2019)' -DeleteContent
Get-Mailbox tclv@royole.com | Search-Mailbox -SearchQuery "(subject:'调休过期通知') AND (FROM:HCM.Notify@royole.com) AND (sent>=10/01/2019) AND (sent<=10/02/2019)" -DeleteContent
```
### Summarize Mails Received Per Day
```PowerShell
$StartDate = Get-Date "2020-07-27"
$EndDate = Get-Date "2020-07-28"

[Int64] $sentCount = 0
[Int64] $receivedCount = 0
[Int64] $sentSize = 0
[Int64] $receivedSize = 0
[DateTime] $processingDate = $StartDate # The date currently being processed.
$result = [System.Collections.ArrayList]@()
while ($processingDate -le $EndDate) {
    # initalize values
    $sentCount = 0
    $receivedCount = 0
    $sentSize = 0
    $receivedSize = 0

    # Get messages from MessageTrackingLog
    Get-TransportService | Get-MessageTrackingLog -ResultSize Unlimited -Start $processingDate -End $processingDate.AddDays(1) | Foreach-Object {
        if ($_.EventId -eq "RECEIVE" -and $_.Source -eq "STOREDRIVER") {
            $sentCount ++
            $sentSize += $_.TotalBytes
        }
        if ($_.EventId -eq "DELIVER") {
            $receivedCount += $_.RecipientCount
            $receivedSize += $_.TotalBytes
        }
        #$sentSize = [Math]::Round($sentSize/1MB, 0)
        #$receivedSize = [Math]::Round($receivedSize/1MB, 0)

    }
    $instance = [pscustomobject] @{
        Date = $processingDate.ToString("yyyy-MM-dd")
        SentCount = $sentCount
        SentSizeByte = $sentSize
        ReceivedCount = $receivedCount
        ReceivedSizeByte = $receivedSize
    }
    $processingDate = $processingDate.AddDays(1)
    $result.Add($instance) |Out-Null
}
```
##### Result
```
Date              SentCount SentSizeByte ReceivedCount ReceivedSizeByte
----              --------- ------------ ------------- ----------------
2020/7/27 0:00:00      4595   3210419289         55109      11034971966
2020/7/28 0:00:00      4325   3313788284         46086      10417686701
```
#### Show Free/Busy Details of Room Mailbox for everyone
```
$rooms = Get-Mailbox -RecipientTypeDetails RoomMailbox
$rooms | %{Set-MailboxFolderPermission $_":\Calendar" -User Default -AccessRights Reviewer}
```

#### Export Mailbox
```
$mailbox
New-MailboxExportRequest -Mailbox $mailbox -FilePath 'xxx.pst'
```
#### Migrate Mailbox
```PowerShell
New-MoveRequest -Identity XXX -TargetDatabase XXX -BatchName XXX -BadItemLimit 50

# example
Get-MailboxDatabase testdb01|Get-Mailbox|ForEach-Object {New-MoveRequest -Identity $_.SamAccountName -TargetDatabase CN8012-STAFF-DB01 -BatchName $_.Name -BadItemLimit 50}
```
#### Install Exchange
Script used: https://gallery.technet.microsoft.com/office/Exchange-2013-Unattended-e97ccda4
```PowerShell
# Add user to security group. After changing user group, log off and log in again.
# Do not use local account to run this script.
$user = "tclyu_admin"
Add-ADGroupMember -Identity "Enterprise Admins" -Members $user
Add-ADGroupMember -Identity "Schema Admins" -Members $user
$Cred = Get-Credential -Message "Provide credentials to install Exchange..." -UserName "logistellar\tclyu_admin"
\\MBP-WD10-PROD\Shares\Exchange\Install-Exchange15.ps1 -Organization "LogiStellar Corporation" -InstallMailbox -MDBDBPath C:\MxsDatabase\MDB01\DB -MDBLogPath C:\MxsDatabase\MDB01\Log -MDBName MDB01 -AutoPilot -Credentials $Cred -SourcePath 'D:\' -SCP https://autodiscover.logistellar.internal/autodiscover/autodiscover.xml -Verbose
# Remove user from security group after installation
Remove-ADGroupMember -Identity "Enterprise Admins" -Members $user
```
#### Install Exchange 2019 Management Tools
https://docs.microsoft.com/en-us/Exchange/plan-and-deploy/prerequisites?view=exchserver-2019

##### Windows 10
Run PowerShell as administrator. The system has to be domain-joined. No pending reboot perior installation.
``` PowerShell
# Install 'Visual C++ Redistributable for Visual Studio 2012'

# Install 'IIS 6 Metabase Compatibility'
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ManagementScriptingTools,IIS-ManagementScriptingTools,IIS-IIS6ManagementCompatibility,IIS-LegacySnapIn,IIS-ManagementConsole,IIS-Metabase,IIS-WebServerManagementTools,IIS-WebServerRole

# Install 'Exchange Management Tools 2019'
D:\Setup.exe /IAcceptExchangeServerLicenseTerms /Role:ManagementTools
```
###### Output
```
PS C:\Windows\system32> D:\Setup.exe /IAcceptExchangeServerLicenseTerms /Role:ManagementTools

Microsoft Exchange Server 2019 Cumulative Update 6 Unattended Setup

Copying Files...
File copy complete.  Setup will now collect additional information needed for installation.

     Languages
     Management tools

Performing Microsoft Exchange Server Prerequisite Check

 Configuring Prerequisites ... COMPLETED
 Prerequisite Analysis ... COMPLETED

Configuring Microsoft Exchange Server

 Preparing Setup ... COMPLETED
 Stopping Services ... COMPLETED
 Copying Exchange Files ... COMPLETED
 Language Files ... COMPLETED
 Restoring Services ... COMPLETED
 Language Configuration ... COMPLETED
 Exchange Management Tools ... COMPLETED
 Finalizing Setup ... COMPLETED

The Exchange Server setup operation completed successfully.
```
#### Services to restart after Exchange Connectors are modified
Restart these services on all servers
```PowerShell
Get-Service "Microsoft Exchange Mailbox Transport Delivery"|Restart-Service
Get-Service "Microsoft Exchange Mailbox Transport Submission"|Restart-Service
Get-Service "Microsoft Exchange Transport"|Restart-Service
Get-Service "Microsoft Exchange Mailbox Assistants"|Restart-Service
```
#### Get Inbox Unread Email Count
``` PowerShell
$emailAddress = 
$UserName = 'LogiStellar\tclyu'
$Password = 
$EwsDllPath = "C:\Users\tclv_adadmin\Documents\net35\Microsoft.Exchange.WebServices.dll"

Add-Type -Path $EwsDllPath
$ews = New-Object Microsoft.Exchange.WebServices.Data.ExchangeService([Microsoft.Exchange.WebServices.Data.ExchangeVersion]::Exchange2016)
$ews.Credentials = New-Object Net.NetworkCredential($UserName, $Password)
$ews.AutodiscoverUrl($emailAddress, {$true})
$maibox = New-Object Microsoft.Exchange.WebServices.Data.Mailbox($emailAddress)

# Get the Mailbox ID of the Inbox folder.
$inboxFolderId = [Microsoft.Exchange.WebServices.Data.FolderId]::new([Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::Inbox,$maibox)

# Bind to the inbox folder.
$boundFolder = [Microsoft.Exchange.WebServices.Data.Folder]::Bind($ews,$inboxFolderId)
$result = New-Object PSObject -Property @{
	EmailAddress = $emailAddress
	UnreadMailCount = $boundFolder.UnreadCount
}
return $result
```
#### Export Transport Rules
```PowerShell
$filePath # end with .xml

$file = Export-TransportRuleCollection -ExportLegacyRules; Set-Content -Path $filePath -Value $file.FileData -Encoding Byte
```
#### Export mailbox delegation
```PowerShell
$exportPath # csv file
Get-Mailbox -ResultSize Unlimited
	| Get-MailboxPermission
		| where {$_.user.tostring() -ne "NT AUTHORITY\SELF" -and $_.IsInherited -eq $false}
			| Select Identity,User,@{Name='AccessRights';Expression={[string]::join(', ', $_.AccessRights)}}
				| Export-Csv -NoTypeInformation $exportPath
```
