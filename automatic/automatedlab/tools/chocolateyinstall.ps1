$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$url64 = 'https://github.com/AutomatedLab/AutomatedLab/releases/download/5.59.0/AutomatedLab.msi'
$fileName = SPlit-Path -leaf $url64
$file = Join-Path $toolsDir -ChildPath $fileName
 
# Download the installer
$downloadArgs = @{
    packageName = $env:ChocolateyPackageName
    FileFullPath = $file
    url64bit = $url64
    checksum64 = '82c6e4d8d37d7e2b19927a18660060bf6c58e1ca7c27ba03c12bc55af1d29390'
    checksumType64 = 'SHA256'
}

Get-ChocolateyWebFile @downloadArgs

# Unblock installer from SmartScreen removing Mark of the Web
Unblock-File $file

# Install the software
$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'msi'
    file      = $file
    validExitCodes = @(0,3010,1641)
    silentArgs     = "/qn /norestart"
}

Install-ChocolateyInstallPackage @packageArgs
