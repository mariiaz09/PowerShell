[CmdletBinding()]
param(
    [Parameter(Mandatory=$True)]
    [string[]]$ComputerName
)
ForEach ($computer in $computername){
    Write-Debug "Preparing to query $computer"
    $session = New-CimSession -ComputerName $computer
    Get-NetFirewallRule -CimSession $session -Enabled True |
    Select-Object -Property DisplayName,Profile,Direction,Action

    Remove-CimSession -CimSession $session

}
####Test this script, run:
C:\DebugScript.ps1 -ComputerName LON-DC1