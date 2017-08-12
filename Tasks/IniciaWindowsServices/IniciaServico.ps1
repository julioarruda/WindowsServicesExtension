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
	$serviceName  = Get-VstsInput -Name serviceName
	$configuraUsuario= Get-VstsInput -Name configuraUsuario
	$serviceUser = Get-VstsInput -Name serviceUser
	$servicePassword = Get-VstsInput -Name servicePassword
    

    $securePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force    
    $credential = New-Object System.Management.Automation.PSCredential($AdminUserName,$securePassword)

    Invoke-Command -ComputerName $EnvironmentName -ScriptBlock {

                     param
                    (
                            [string]$AdminUserName,
                            [string]$AdminPassword,
                            [string]$serviceName,
							[string]$configuraUsuario,
							[string]$serviceUser,
							[string]$servicePassword
                            
                        
                    )
                
				
					foreach($servico in $serviceName.Split(','))
					{
						if($configuraUsuario -eq "true")
						{
							$svcD=Get-WmiObject -Class Win32_Service -Filter "Name='$servico'"
							$ChangeStatus = $svcD.change($null,$null,$null,$null,$null,$null,$serviceUser,$servicePassword,$null,$null,$null) 
							If ($ChangeStatus.ReturnValue -eq "0")  
								{write-host " User Changed Sucefull"} 
						}
						Start-Service "$servico"
					}
                
    } -SessionOption $sessionOptions -ArgumentList @($AdminUserName,$AdminPassword,$serviceName,$configuraUsuario,$serviceUser,$servicePassword) -Credential $credential    

} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}