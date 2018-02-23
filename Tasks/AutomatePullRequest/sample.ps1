[CmdletBinding()]
param()
Import-Module .\ps_modules\VstsTaskSdk
# For more information on the VSTS Task SDK:
# https://github.com/Microsoft/vsts-task-lib
Trace-VstsEnteringInvocation $MyInvocation
try {
    $repository= Get-VstsInput -Name repository
    $sourcebranch= Get-VstsInput -Name sourcebranch
    $targetbranch= Get-VstsInput -Name targetbranch
    $apiVersion= Get-VstsInput -Name apiVersion
    $pat= Get-VstsInput -Name pat

    .\PullRequest.ps1 $repository $sourcebranch $targetbranch $api $pat
    
    

    # Output the message to the log.
    Write-Host (Get-VstsInput -Name msg)
} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
