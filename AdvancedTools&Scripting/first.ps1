#PowerShell Advanced Tools and Scripting 
##Use full path to avoid lurking attack 

#Variables to store things
#Assigning a variable 
$MyVar=2
${My Var}="Hello"

#Output a variable
$MyVar
${My Var}
Write-Output $MyVar
#Strongly type a variable 
[String] $MyName="Mariia"
[String]$computerName=Read-host "Enter computer name"
Write-Output $ComputerName

[validateset("a","b","c")][string]$x = "a"

