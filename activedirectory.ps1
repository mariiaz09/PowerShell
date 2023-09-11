Creating and managing Active Directory objects

1. Creating a new organizational unit for a branch office
New-ADOrganizationalUnit -Name London

2.Create a group for branch office admins
New-ADGroup "London Admins" -GroupScope Global

3. Create a user and computer account for the branch office
New-ADUser -Name Joe -DisplayName "Joe Doe"
Add-ADGroupMember "London Admins" -Members Joe
New-ADComputer LON-CL2
4.Move the group, user, and computer accounts to the branch office OU
Move-ADObject -Identity "CN=London Admins,CN=Users,DC=Adatum,DC=com" -TargetPath "OU=London,DC=Adatum,DC=com"
Move-ADObject -Identity "CN=Ty,CN=Users,DC=Adatum,DC=com" -TargetPath "OU=London,DC=Adatum,DC=com"
Move-ADObject -Identity "CN=LON-CL2,CN=Computers,DC=Adatum,DC=com" -TargetPath "OU=London,DC=Adatum,DC=com"

Configuring network setting on WS 
1. Test the network connection and review the configuration
Test-Connection LON-DC1
Get-NetIPConfiguration
2. Change the server IP address
New-NetIPAddress -InterfaceAlias Ethernet -IPAddress 172.16.0.15 -PrefixLength 16
Remove-NetIPAddress -InterfaceAlias Ethernet -IPAddress 172.16.0.11
3.Change the DNS setting and default gateway for the server
Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddress 172.16.0.12
Remove-NetRoute -InterfaceAlias Ethernet -DestinationPrefix 0.0.0.0/0 -Confirm:$false
New-NetRoute -InterfaceAlias Ethernet -DestinationPrefix 0.0.0.0/0 -NextHop 172.16.0.2

Creating a website
1. Install the Web Server role on the server
Install-WindowsFeature Web-Server
2. Create a folder on the server for website files
New-Item C:\inetpub\wwwroot\London -Type directory
3. Create the ISS website
New-IISSite London -PhysicalPath C:\inetpub\wwwroot\london -BindingInformation "172.16.0.15:8080:"




