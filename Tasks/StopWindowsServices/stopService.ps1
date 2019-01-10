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
								Write-Host "Serviço '$serviceName' parado com sucesso!"
							}
							catch {								
								$connError = $_.Exception.Message
								Write-Warning "[Tentativa $tentatives de $maxRetries]: Falha ao parar o serviço '$ServiceName'. Erro: $connError"
								Start-Sleep -Seconds 5
							}	
						} until (($tentatives -ge $maxRetries) -or ($success))
						
						if (!$success){
							Write-Error $connError
						}
						
					}
					else{
						Write-Host "Serviço '$serviceName' não estava sendo executado."
					}
				}
			}
			else{
				Write-Warning "Serviço '$serviceName' não encontrado."
			}
		}
		catch{
			$connError = $_.Exception.Message
			Write-Error "Falha ao parar o serviço '$ServiceName'. Erro: $connError"
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
		#Utilizando a execução via "&" pois Invoke-Command faz com que o scriptblock seja executado fora do escopo de Administrator
		& $scriptBlock -serviceName $ServiceName
	}
	
} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
