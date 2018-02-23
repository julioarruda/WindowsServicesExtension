[CmdletBinding()]
param()
Import-Module .\ps_modules\VstsTaskSdk

# For more information on the VSTS Task SDK:
# https://github.com/Microsoft/vsts-task-lib
Trace-VstsEnteringInvocation $MyInvocation
try {
    Import-VstsLocStrings "$PSScriptRoot\Task.json"

    # Get the inputs.

    $EnvironmentName = Get-VstsInput -Name EnvironmentName
    $AdminUserName = Get-VstsInput -Name AdminUserName
    $AdminPassword = Get-VstsInput -Name AdminPassword
    $ServiceName = Get-VstsInput -Name ServiceName
    $runRemote= Get-VstsInput -Name runRemote

    $securePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force    
    $credential = New-Object System.Management.Automation.PSCredential($AdminUserName,$securePassword)

    $scriptBlock = {
		param(
			[string]$serviceName
		)

		Write-Host "Serviço que será parado: "$serviceName
	
		try{			
			if(Get-Service $serviceName -ErrorAction SilentlyContinue){
				$maxRetries = 3
				$services = @(Get-Service $ServiceName)
				foreach ($service in $services){
					if ($service.Status -eq 'Running'){
						$tentatives = 0
						$success = $false
						do {							
							try {
								$tentatives++
								$service | Stop-Service								
								$success = $true
								Write-Host "Service '$serviceName' stoped sucefull!"
							}
							catch {								
								$connError = $_.Exception.Message
								Write-Warning "[Attemp $tentatives to $maxRetries]: Fail to stop the Service '$ServiceName'. Error: $connError"
								Start-Sleep -Seconds 5
							}	
						} until (($tentatives -ge $maxRetries) -or ($success))
						
						if (!$success){
							Write-Error $connError
						}
						
					}
					else{
						Write-Host "The Service '$serviceName' was not been running."
					}
				}
			}
			else{
				Write-Warning "Service '$serviceName' not found."
			}
		}
		catch{
			$connError = $_.Exception.Message
			Write-Error "Fail to stop the Service '$ServiceName'. Error: $connError"
		}
	}


	if ($runRemote -eq "True") {
		$securePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force    
		$credential = New-Object System.Management.Automation.PSCredential($AdminUserName,$securePassword)
		$allServers = $EnvironmentName.Split(',').Trim();

		foreach($maquina in $allServers){
			Invoke-Command -ComputerName $maquina -ScriptBlock $scriptBlock -SessionOption $sessionOptions -ArgumentList @($ServiceName) -Credential $credential
		}			
	}
	else {
		#Running using "&" because Invoke-Command so that the scriptblock running without Administrator scope
		& $scriptBlock -serviceName $ServiceName
	}  

} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
