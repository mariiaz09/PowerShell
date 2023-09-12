#Create user account for John Doe in London OU 
New-ADUser -Name John -DisplayName "John Doe" -GivenName John -Surname Doe -Path "ou=London,dc=Adatum,dc=com"

#Set the password for the account
Set-ADAccountPassword John

#Enable the user account
Enable-ADAccount John