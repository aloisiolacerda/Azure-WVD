﻿param(
      [string]$registrationToken
)
# agents
# wvd agent
$msiFile =  Get-Item 'Microsoft.RDInfra.WVDAgent.Installer*'
Write-host $msiFile

$execarg = @(
    "/i"
    "$msiFile"
    "/passive"
    "REGISTRATIONTOKEN=$registrationToken"
)
Write-host "Installing WVD Agent..."
Start-Process msiexec.exe -Wait -ArgumentList $execarg

# wvd agent manager
Write-host "Installing WVD Agent Manager..."
$msiFile =  Get-Item 'Microsoft.RDInfra.WVDAgentManager*'
$execarg = @(
    "/i"
    "$msiFile" 
    "/passive"
)
Start-Process msiexec.exe -Wait -ArgumentList $execarg

# checks 
Write-host "Agent Status:$((Get-Service WVDAgent).Status)"

Write-host "Verifiying WVD Agent registry keys"
if ((Test-Path -Path "HKLM:\SOFTWARE\Microsoft\WVDAgentManager") -eq $false) {(Start-Sleep -s 60)} ELSE {Write-host "WVD Agent Registry entry found."}
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WVDAgentManager"


if ((Test-Path -Path "HKLM:\SOFTWARE\Microsoft\RDAgentBootLoader") -eq $false) {(Start-Sleep -s 60)} ELSE {Write-host "WVD Agent Manager Registry entry found."}
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\RDAgentBootLoader"

Write-host "Installation completed."