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

    $securePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force    
    $credential = New-Object System.Management.Automation.PSCredential($AdminUserName,$securePassword)

    Invoke-Command -ComputerName $EnvironmentName -ScriptBlock {

                param(
                    [string]$serviceName
                )
                Write-Host "Serviço que será parado: "$serviceName
               
               Try{
                   if(Get-Service $serviceName -ErrorAction SilentlyContinue)
                   {
                        $services = @(Get-Service $ServiceName)
                        foreach ($service in $services)
                        {
                            if ($service.Status -eq 'Running')
                            {
                                $service | Stop-Service
                            }
                        }
                   }
                   else
                   {Write-Host "O Serviço não existe"}

               }
              Catch{
                  Write-Host "Falha ao Parar o Serviço ou Serviço não existe" -
              }


    } -SessionOption $sessionOptions -ArgumentList @($ServiceName) -Credential $credential    

} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
