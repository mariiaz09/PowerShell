Creating and managing Active Directory objects

1. Creating a new organizational unit for a branch office
New-ADOrganizationalUnit -Name London

2.Create a group for branch office admins
New-ADGroup "London Admins" -GroupScope Global

3. Create a user and computer account for the branch office
New-ADUser -Name Joe -DisplayName "Joe Doe"
Add-ADGroupMember "London Admins" -Members Joe
New-ADComputer LON-CL2



