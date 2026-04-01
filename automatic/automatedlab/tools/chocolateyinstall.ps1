$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$url64 = 'https://github.com/AutomatedLab/AutomatedLab/releases/download/5.60.0/AutomatedLab.msi'
$fileName = SPlit-Path -leaf $url64
$file = Join-Path $toolsDir -ChildPath $fileName
 
# Download the installer
$downloadArgs = @{
    packageName = $env:ChocolateyPackageName
    FileFullPath = $file
    url64bit = $url64
    checksum64 = 'c2250a6406a31d5a9581e882d9be9c4663a60bff75d752d2e24beb1e1035a9a8'
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
