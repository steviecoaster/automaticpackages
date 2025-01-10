$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$url64 = ''
$fileName = SPlit-Path -leaf $url64
$file = Join-Path $toolsDir -ChildPath $fileName
 
# Download the installer
$downloadArgs = @{
    packageName = $env:ChocolateyPackageName
    FileFullPath = $file
    url64bit = $url64
    checksum64 = ''
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
    silentArgs     = "/qn /norestart /l*v '$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log'"
}

Install-ChocolateyInstallPackage @packageArgs
