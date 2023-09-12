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

Create list of computers with a particular operating system installed 

Create list of computers that have not logged onto the network within 30 days 

Automatically remove items from Downloads folders 60+ days old 

Create script to remote restart computer 

Retrieve disk size and amount of free space on a remote host 

Stop and start process on remote host 

Stop and start services on remote host 

#Retrieve a list of printers installed on a computer 
Get-WmiObject -Query "SELECT * FROM Win32_Printer" | Select-Object Name, PortName, DriverName


List Ip address for a remote host 

Retrieve network Adapter properties for remote computers 

Release and renew DHCP leases on Adapters 

Create a network Share  
