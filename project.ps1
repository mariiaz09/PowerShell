#Install AD DS on a server from DC
Install-WindowsFeature -Name AD-Domain-Services -ComputerName LON-SVR1
#Check if Installed
Get-WindowsFeature -ComputerName LON-SVR1
#Create bulk Users 
Import-Csv -Path "C:\path\to\users.csv" | ForEach-Object {
    New-ADUser -SamAccountName $_.SamAccountName `
               -Name $_.Name `
               -GivenName $_.GivenName `
               -Surname $_.Surname `
               -UserPrincipalName $_.UserPrincipalName `
               -Path $_.Path `
               -AccountPassword (ConvertTo-SecureString $_.AccountPassword -AsPlainText -Force) `
               -Enabled $true  # You can set other attributes as needed
}

#Enumerate expired user accounts 
Get-ADUser -Filter {AccountExpires -lt [datetime]::Now} -Properties AccountExpires | Select-Object Name, SamAccountName, AccountExpires


#Enumerate user accounts expired within last 24-hour period 
Get-ADUser -Filter {AccountExpires -ge [datetime]::Now.AddDays(-1) -and AccountExpires -lt [datetime]::Now} -Properties AccountExpires | Select-Object Name, SamAccountName, AccountExpires

#Locate and unlock specific user account 
Get-ADUser -Filter {SamAccountName -eq "Username"} | Unlock-ADAccount

#Retrieve all locked accounts 
Search-ADAccount -LockedOut | Select-Object Name, SamAccountName

#Disable user accounts that have that have not been used to logon with in 30 or more days 
$LastLogonThreshold = (Get-Date).AddDays(-30)

Get-ADUser -Filter {LastLogonTimestamp -lt $LastLogonThreshold -and Enabled -eq $true} -Properties LastLogonTimestamp |
    Set-ADUser -Enabled $false

#Move disabled users into a specific OU 
$DisabledUsers = Get-ADUser -Filter {Enabled -eq $false}

foreach ($User in $DisabledUsers) {
    Move-ADObject -Identity $User -TargetPath "OU=YourTargetOU,DC=yourdomain,DC=com"
}


#Remove Disabled Users from all Security Groups except Domain Users 
# Define the name of the excluded group (e.g., "Domain Users")
$excludedGroupName = "Domain Users"

# Get all disabled users
$disabledUsers = Get-ADUser -Filter {Enabled -eq $false}

# Iterate through all security groups in the domain
Get-ADGroup -Filter {GroupCategory -eq "Security"} | ForEach-Object {
    $group = $_
    
    # Exclude the "Domain Users" group from modifications
    if ($group.Name -ne $excludedGroupName) {
        Write-Host "Processing $($group.Name)..."
        
        # Iterate through the members of the group
        $groupMembers = Get-ADGroupMember -Identity $group
        foreach ($member in $groupMembers) {
            # Check if the member is a disabled user
            if ($disabledUsers | Where-Object { $_.DistinguishedName -eq $member.DistinguishedName }) {
                Write-Host "Removing $($member.Name) from $($group.Name)..."
                Remove-ADGroupMember -Identity $group -Members $member -Confirm:$false
            }
        }
    }
}


#Add Users into Groups 
Add-ADGroupMember -Identity "GroupName" -Members "User1", "User2", "User3"


#Create OUs 
New-ADOrganizationalUnit -Name "NewOU" -Path "OU=ParentOU,DC=example,DC=com"

#Create Groups 
New-ADGroup -Name "MyGroup" -SamAccountName "MyGroup" -GroupCategory Security -GroupScope Global -DisplayName "My Group" -Path "OU=Groups,DC=example,DC=com"

##Create list of computers with a particular operating system installed 
#// Set CSV file name 
    $uDateTime = Get-Date -f "yyyy-MM" 
    $uCSVFile = "C:\Servers"+$uDateTime+".csv" 

    #//Export out to csv file.
    Get-ADComputer -filter * -Properties ipv4Address, OperatingSystem,DistinguishedName | 
    select-object Name, ipv4Address, OperatingSystem,  @{label='OU';expression= 
    {$_.DistinguishedName.Split(',')[1].Split('=')[1]}} |
    export-csv -path $uCSVFile


##Create list of computers that have not logged onto the network within 30 days 
$thresholdDate = (Get-Date).AddDays(-30)

Get-ADComputer -Filter {LastLogonDate -lt $thresholdDate} -Property LastLogonDate | Select-Object Name, LastLogonDate


#Automatically remove items from Downloads folders 60+ days old 
# Define the path to the Downloads folder
$DownloadsFolder = [System.Environment]::GetFolderPath('Downloads')

# Define the threshold date (60+ days ago)
$ThresholdDate = (Get-Date).AddDays(-60)

# Get all files in the Downloads folder that are older than the threshold date
$OldFiles = Get-ChildItem -Path $DownloadsFolder | Where-Object { $_.LastWriteTime -lt $ThresholdDate }

# Delete each old file
foreach ($File in $OldFiles) {
    Write-Host "Deleting $($File.Name)..."
    Remove-Item -Path $File.FullName -Force
}

Write-Host "Cleanup completed."


#Create script to remote restart computer
Restart-Computer -ComputerName REMOTE_COMPUTER_NAME -Force

#Retrieve disk size and amount of free space on a remote host 
$disk = Get-WmiObject Win32_LogicalDisk -ComputerName remotecomputer -Filter "DeviceID='C:'" |
Foreach-Object {$_.Size,$_.FreeSpace}

##Stop and start process on remote host 
# Remote computer name or IP address
$RemoteComputer = "RemoteComputerNameOrIPAddress"

# Process name to stop and start
$ProcessName = "ProcessName"

# Stop the process on the remote computer
Invoke-Command -ComputerName $RemoteComputer -ScriptBlock {
    param($ProcessName)
    Stop-Process -Name $ProcessName -Force
} -ArgumentList $ProcessName

# Start the process on the remote computer
Invoke-Command -ComputerName $RemoteComputer -ScriptBlock {
    param($ProcessName)
    Start-Process -Name $ProcessName
} -ArgumentList $ProcessName


#Stop and start services on remote host 
Invoke-Command -ComputerName "RemoteComputer" -ScriptBlock {
    Stop-Service -Name "ServiceName" -Force
}
Invoke-Command -ComputerName "RemoteComputer" -ScriptBlock {
    Start-Service -Name "ServiceName"
}


#Retrieve a list of printers installed on a computer 
Get-WmiObject -Query "SELECT * FROM Win32_Printer" | Select-Object Name, PortName, DriverName


#List Ip address for a remote host 
Test-Connection -ComputerName "RemoteHostName" | Select-Object -ExpandProperty IPV4Address

#Retrieve network Adapter properties for remote computers 
$Computers = "RemoteComputer1", "RemoteComputer2"  # Replace with the names of the remote computers you want to query

foreach ($Computer in $Computers) {
    Write-Host "Network Adapter Properties for $Computer:"
    
    $NetworkAdapters = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $Computer
    foreach ($Adapter in $NetworkAdapters) {
        Write-Host "Adapter Description: $($Adapter.Description)"
        Write-Host "IP Address(es): $($Adapter.IPAddress -join ', ')"
        Write-Host "Subnet Mask(s): $($Adapter.IPSubnet -join ', ')"
        Write-Host "Default Gateway(s): $($Adapter.DefaultIPGateway -join ', ')"
        Write-Host "DNS Server(s): $($Adapter.DNSServerSearchOrder -join ', ')"
        Write-Host "MAC Address: $($Adapter.MACAddress)"
        Write-Host ""
    }
}

#Release and renew DHCP leases on Adapters 
# Release DHCP lease for a specific network adapter
Invoke-Command -ScriptBlock { ipconfig /release } -AsJob -RunAsAdministrator -ComputerName localhost

# Renew DHCP lease for the same network adapter
Invoke-Command -ScriptBlock { ipconfig /renew } -AsJob -RunAsAdministrator -ComputerName localhost

#Create a network Share 
New-SmbShare -Name "MyShare" -Path "C:\SharedFolder" -FullAccess "Everyone" -Description "My Shared Folder"

