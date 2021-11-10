param (
    [Parameter()]
    [String[]]
    $Services
)

# Loop through the service's name array, if service is running then stop service and disable it
foreach ($service in $Services) {

  for ($i = 0; $i -lt 3; $i++) {

    $getServiceStatus = (Get-Service -Name $service).Status
    if ($getServiceStatus -eq "Stopped") {

      Continue

    }

    else {

      Stop-Service -Name $service
      Start-Sleep -Seconds 2

    }

  }

  $getServiceStartupType = (Get-Service -Name $service).StartType
  if ($getServiceStartupType -eq "Disabled") {

    Continue

  } else {
    
    Set-Service -Name $service -StartupType "Disabled"

  }

}


# check if service has been stopped and disabled yet
foreach ($service in $Services) {

  $getServiceAfterOps = Get-Service -Name $service
  if ($getServiceAfterOps.Status -eq "Stopped") {

    Write-Host "[INFO] Service $($service) is Stopped"

  } else {

    Write-Host "[ERROR] Service $($service) is running"

  }

  if ($getServiceAfterOps.StartupType -eq "Disabled") {
    
    Write-Host "[INFO] Service $($service) is Disabled"

  } else {
    
    Write-Host "[ERROR] Service $($service) is not Disabled"

  }

}
