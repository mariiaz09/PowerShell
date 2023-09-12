#To create a new group
New-ADGroup LondonBranchUsers -Path "ou=London,dc=Contoso,dc=com" -GroupScope Global -GroupCategory Security

#Add a member to group
Add-ADGroupMember LondonBranchUsers -Members John
#Confirm that the user has been added 
Get-ADGroupMember LondonBranchUsers