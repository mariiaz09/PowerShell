#Install AD DS on a server from DC
Install-WindowsFeature -Name AD-Domain-Services -ComputerName LON-SVR1
#Check if Installed
Get-WindowsFeature -ComputerName LON-SVR1

Create bulk Users 

Enumerate expired user accounts 

Enumerate user accounts expired within last 24-hour period 

Locate and unlock specific user account 

Retrieve all locked accounts 

Disable user accounts that have that have not been used to logon with in 30 or more days 

Move disabled users into a specific OU 

Remove Disabled Users from all Security Groups except Domain Users 

Add Users into Groups 

Create OUs 

Create Groups 

Create list of computers with a particular operating system installed 

Create list of computers that have not logged onto the network within 30 days 

Automatically remove items from Downloads folders 60+ days old 

Create script to remote restart computer 

Retrieve disk size and amount of free space on a remote host 

Stop and start process on remote host 

Stop and start services on remote host 

Retrieve a list of printers installed on a computer 

List Ip address for a remote host 

Retrieve network Adapter properties for remote computers 

Release and renew DHCP leases on Adapters 

Create a network Share  
