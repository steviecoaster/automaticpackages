$ErrorActionPreference = "Stop"
$toolsdir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$url = 'https://proget.inedo.com/upack/Products/download/InedoReleases/DesktopHub/1.6.0?contentOnly=zip'
$pp = Get-PackageParameters

# Create the unzip location
$unzipLocation = if ($pp['Destination']) {
  $pp['Destination']
}
else {
  'C:\InedoHub\'
}

$zipArgs = @{
  PackageName   = $env:ChocolateyPackageName
  Url           = $url
  UnzipLocation = $unzipLocation
  Checksum      = 'E891450EC0C4496457E156F12F2B5AE67AA6B65062F95F272627E364B1164E37'
  ChecksumType  = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs

#Set system path location for easy execution
Install-ChocolateyPath -Path $unzipLocation -PathType 'Machine'

# Write text file to document unzip location for use with uninstallation
Set-Content -Path (Join-Path $toolsdir -ChildPath 'uninstall.txt') -Value $unzipLocation

