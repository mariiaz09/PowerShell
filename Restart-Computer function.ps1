Function Restart-Computer {
    Param (
        [string[]]$ComputerName1,
        [string[]]$ComputerName2
    )
    ForEach ($computer1 in $ComputerName1) {
        $os1 = GetInstance -ClassName Win32_OperatingSystem -Computername $computer1 -Property LastBootUptime, CSName
        Write-Output -InputObject "$($os2.CSName) last boot uptime is $($os1.LastBootUpTime)"
    }
    ForEach ($computer2 in $ComputerName2) {
        $os2 = GetInstance -ClassName Win32_OperatingSystem -Computername $computer2 -Property LastBootUptime, CSName
        Write-Output -InputObject "$($os2.CSName) last boot uptime is $($os2.LastBootUpTime)"
       }
    }
    $computerName1 = @('LON-SVR1')
    $computerName2 = @('LON-DC1')

    # to test this script, run:
    Restart-Computer -ComputerName1 $computerName1 -ComputerName2 $computerName2
##############################################################################################################
    Workflow Restart-Computer {
    Param (
        [string[]]$ComputerName1,
        [string[]]$ComputerName2
    )
    ForEach -parallel($computer1 in $ComputerName1) {
        $os1 = GetInstance -ClassName Win32_OperatingSystem -PSComputername $computer1 -Property LastBootUptime, CSName
        Write-Output -InputObject "$($os2.CSName) last boot uptime is $($os1.LastBootUpTime)"
    }
    ForEach -parallel($computer2 in $ComputerName2) {
        $os2 = GetInstance -ClassName Win32_OperatingSystem -PSComputername $computer2 -Property LastBootUptime, CSName
        Write-Output -InputObject "$($os2.CSName) last boot uptime is $($os2.LastBootUpTime)"
       }
    }
    $computerName1 = @('LON-SVR1')
    $computerName2 = @('LON-DC1')

    # to test this workflow, run:
    Restart-Computer -ComputerName1 $computerName1 -ComputerName2 $ComputerName2
    # to test this workflow as a job, run:
    Restart-Computer -ComputerName1 $computerName1 -ComputerName2 $ComputerName2 -AsJob -JobName RestartComputer
    #to retrieve results when running the workflow as a job,run:
    Receive-Job -Name RestartComputer



