$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$url64 = 'https://github.com/Devolutions/jiffshot/releases/download/v0.9.0/Devolutions.Jiffshot-windows-x64-0.9.0.msi'
$fileName = SPlit-Path -leaf $url64
$file = Join-Path $toolsDir -ChildPath $fileName
 
# Download the installer
$downloadArgs = @{
    packageName = $env:ChocolateyPackageName
    FileFullPath = $file
    url64bit = $url64
    checksum64 = 'db805e349f4435cc25b29603ebc21d47b3356685e089b94e910a762b51c1b76e'
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
