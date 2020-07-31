$ErrorActionPreference = 'Stop'; # stop on all errors

If((Get-Service PowerShellUniversal).Status -eq 'Running'){
  Get-Service PowerShellUniversal | Stop-Service
}

$pp = Get-PackageParameters

if(!(Test-Path $pp['License'])){
    throw "License file not found. Check the path and try again."
}

$key = Get-Content $pp['License']

@"
Set-PSULicense -Key "$key"
"@ | Set-Content C:\ProgramData\UniversalAutomation\Repository\.universal\licenses.ps1

Start-Service PowerShellUniversal