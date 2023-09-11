
#Using PowerShell pipeline
=======
Selecting, sorting, and displaying data
1. Display the current day of the year
help *date*
Get-Date | Get-Member
Get-Date | Select-Object –Property DayOfYear
Get-Date | Select-Object -Property DayOfYear | fl
2. Display information about installed hotfixes
Get-Command *hotfix*
Get-Hotfix | Get-Member
 Get-Hotfix | Select-Object –Property HotFixID,InstalledOn,InstalledBy
 Get-Hotfix | Select-Object –Property HotFixID,@{n='HotFixAge';e={(New-TimeSpan -Start $PSItem.InstalledOn).Days}},InstalledBy
 3. Display a list of available scopes from the DHCP server
 help *scope*
Help Get-DHCPServerv4Scope –ShowWindow
Get-DHCPServerv4Scope –ComputerName LON-DC1
Get-DHCPServerv4Scope –ComputerName LON-DC1 | Select-Object –Property ScopeId,SubnetMask,Name | fl
4. Display a sorted list of enabled Windows Firewall rules
help *rule*
Get-NetFirewallRule
Help Get-NetFirewallRule –ShowWindow
Get-NetFirewallRule –Enabled True
Get-NetFirewallRule –Enabled True | Format-Table -wrap
Get-NetFirewallRule –Enabled True | Select-Object –Property DisplayName,Profile,Direction,Action | Sort-Object –Property Profile, DisplayName | ft -GroupBy Profile
5. Display a sorted list of network neighbors 
help *neighbor*
help Get-NetNeighbor –ShowWindow
Get-NetNeighbor
Get-NetNeighbor | Sort-Object –Property State
Get-NetNeighbor | Sort-Object –Property State | Select-Object –Property IPAddress,State | Format-Wide -GroupBy State -AutoSize






>>>>>>> c4b628a5ede30c47e1dc97ce60ee9a01582db0b9