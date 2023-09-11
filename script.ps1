//Sending greeting function
function Send-Greeting {
[CmdletBinding()]
Param(
[Parameter(Mandatory=$true)]
[string] $Name 
)
Process {
Write-Host ("Hello " + $Name + "!")
 }
}

## Set ADUser Expiration date and time
$user = Read-Host 'AD username set to expire'
Set-ADAccountExpiration -Identity $user -DateTime '12/08/2016 17:00:00'
Get-ADUser -Identity $user -Properties AccountExpirationDate | Select-Object -Property SamAccountName, AccountExpirationDate
