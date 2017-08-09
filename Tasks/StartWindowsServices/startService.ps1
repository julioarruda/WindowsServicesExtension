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
                            [string]$startupType
                        
                    )
                $securePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force    
                $credential = New-Object System.Management.Automation.PSCredential($AdminUserName,$securePassword)

            if (Get-Service "$ServiceName" -ErrorAction SilentlyContinue)
            {
                $service = Get-WmiObject -Class Win32_Service -Filter "Name='$ServiceName'"
                $service.delete()
            }
            
            New-Service -Name "$ServiceName" -BinaryPathName "$ServiceFolder" -DisplayName "$ServiceName" -Credential $credential -StartupType $startupType
               
                if($iniciaServico -eq "true")
                {
                    Start-Service "$ServiceName"
                }

    } -SessionOption $sessionOptions -ArgumentList @($AdminUserName,$AdminPassword,$ServiceName,$ServiceFolder,$iniciaServico,$startupType) -Credential $credential    

} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}