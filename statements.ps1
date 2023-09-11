##switch statement
$object = "pencil"
Switch($object) {
"pencil" {Write-Host "That's correct"; break }
"water"  {Write-Host "Water is not an object"; break }
"cat" {Write-Host "Cat is an animal"; break }
"sky"  {Write-Host "Sky is not an object"; break }
}
##ifelse
$total = 255
If ($total -ge 1 -and $total -le 151) {
Write-Host " You got total"
} elseif($total -ge 152 -and $total -le 251)  {
Write-Host "Blue"
} elseif($total -ge 252 -and $total -le 300)  {
Write-Host "Red"
}
##General Info
##Check version
$PSVersionTable.PSVersion
##Check current execution policy
Get-ExecutionPolicy  
##Set new execution policy
Set-ExecutionPolicy Restricted**
##Script
Write-Host "Hello World" -NoNewline
Write-Host "Hello World"
#Get cmdlet
Get-Command -CommandType Cmdlet
Get-Help New-ADUser -Full
"Today is great day" | Out-file source.txt
cat .\source.txt
#Variables
$fruit = "plum"
$fruit | Out-file source.txt
##Getting all available methods for this specific object
Get-Member -InputObject $fruit
$animals = @('cat','dog', 'bird')
$animals += "tiger", "rat"
#hashtable
$grocery = @{item1 = "bread"; item2 = "meat"}
#adding to hash table 
$grocery.Add("item3","icecream")
$grocery.Set_Item("item4","soup")
##user input 
$FavMovie =  Read-Host -Prompt "What is your favorite movie"

##some active directory things
###### Make sure the AD recyclebin is enabled ######
##AD USER Recovery
$Name=read-host "Enter the deleted user"
Get-ADObject -Filter 'samaccountname -eq $name' -IncludeDeletedObjects | Restore-ADObject
write-host "User $Name is recovered" -ForegroundColor DarkGreen

##disable active directory user
#Wintel-AD-Disable Active Directory User:

#for single:
Import-Module ActiveDirectory
Disable-ADAccount -Identity user1

#for bulk:

#imports active directory module to only corrent session as it is related to AD

Import-Module ActiveDirectory

#Takes input from users.csv file into this script

Import-Csv "C:\Users.csv" | ForEach-Object {

#assign input value to variable-samAccountName 

$samAccountName = $_."samAccountName"

#get-aduser will retrieve samAccountName from domain users. if we found it will disable else it will go to catch

try { Get-ADUser -Identity $samAccountName |
Disable-ADAccount  
}

#It will run when we can't find user

catch {

#it will display the message

  Write-Host "user:"$samAccountname "is not present in AD"
}
}
