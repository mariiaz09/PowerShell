function Get-DiskInfo {
[CmdletBinding()]
Param(
[Parameter(Mandatory=$True)]
[string[]] $computerName
)
Process {
foreach ($computer in $computerName){
$disks = Get-CimInstance -ComputerName $computer -ClassName Win32_LogicalDisk
foreach ($disk in $disks) {
$properties = @{'ComputerName' = $computer;
                'DriveLetter' = $disk.deviceid;
                'FreeSpace' = $disk.freespace;
                'Size' = $disk.size}

    $output = New-Object -TypeName PSObject -Property $properties
    Write-Output $output
    }
   }
  }
 }
