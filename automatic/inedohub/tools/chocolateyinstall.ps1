$ErrorActionPreference = "Stop"
$toolsdir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$url = 'https://proget.inedo.com/upack/Products/download/InedoReleases/DesktopHub/1.5.3?contentOnly=zip'
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
  Checksum      = '15A7FACB90F83992AFC4615D04293AAE0310E3C5F1F32AC302A0E401F027521F'
  ChecksumType  = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs

#Set system path location for easy execution
Install-ChocolateyPath -Path $unzipLocation -PathType 'Machine'

# Write text file to document unzip location for use with uninstallation
Set-Content -Path (Join-Path $toolsdir -ChildPath 'uninstall.txt') -Value $unzipLocation

