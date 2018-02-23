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
    $ServiceFolder = Get-VstsInput -Name ServiceFolder
    $startupType = Get-VstsInput -Name startupType
    $iniciaServico = Get-VstsInput -Name iniciaServico
    $usaInstallutil = Get-VstsInput -Name usaInstallutil
	$installutilpath = Get-VstsInput -Name installutilpath
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
                            [string]$ServiceName,
                            [string]$serviceFolder,
                            [string]$iniciaServico,
                            [string]$startupType,
                            [string]$usaInstallutil,
                            [string]$installutilpath,
							[string]$configuraUsuario,
							[string]$serviceUser,
							[string]$servicePassword
                        
                    )
			if($configuraUsuario -eq "true")
			{
				$securePassword = ConvertTo-SecureString $servicePassword -AsPlainText -Force    
				$credential = New-Object System.Management.Automation.PSCredential($serviceUser,$securePassword)
			}
			else{
				$securePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force    
				$credential = New-Object System.Management.Automation.PSCredential($AdminUserName,$securePassword)
			}
            if (Get-Service "$ServiceName" -ErrorAction SilentlyContinue)
            {
                $service = Get-WmiObject -Class Win32_Service -Filter "Name='$ServiceName'"
                $service.delete()
            }
            
            if($usaInstallutil -eq "true")
			{
                
				$run = $installutilpath + " " + "'$ServiceFolder'"
                Invoke-Expression $run
				
				if($configuraUsuario -eq "true")
				{
					$svcD=Get-WmiObject -Class Win32_Service -Filter "Name='$ServiceName'"
					$ChangeStatus = $svcD.change($null,$null,$null,$null,$null,$null,$serviceUser,$servicePassword,$null,$null,$null) 
					If ($ChangeStatus.ReturnValue -eq "0")  
						{write-host " User Changed Sucefull"} 
				}

			}
			else{
				New-Service -Name "$ServiceName" -BinaryPathName "$ServiceFolder" -DisplayName "$ServiceName" -Credential $credential -StartupType $startupType
			}
			
			
               
            if($iniciaServico -eq "true")
            {
                Start-Service "$ServiceName"
            }

    } -SessionOption $sessionOptions -ArgumentList @($AdminUserName,$AdminPassword,$ServiceName,$ServiceFolder,$iniciaServico,$startupType,$usaInstallutil,$installutilpath,$configuraUsuario,$serviceUser,$servicePassword) -Credential $credential    

} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
