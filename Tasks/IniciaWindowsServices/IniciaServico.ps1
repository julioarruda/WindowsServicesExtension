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
    

    $securePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force    
    $credential = New-Object System.Management.Automation.PSCredential($AdminUserName,$securePassword)

    Invoke-Command -ComputerName $EnvironmentName -ScriptBlock {

                     param
                    (
                            [string]$AdminUserName,
                            [string]$AdminPassword,
                            [string]$serviceName
                            
                        
                    )
                
				
					foreach($servico in $serviceName.Split(','))
					{
						Start-Service "$servico"
					}
                
    } -SessionOption $sessionOptions -ArgumentList @($AdminUserName,$AdminPassword,$serviceName) -Credential $credential    

} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}