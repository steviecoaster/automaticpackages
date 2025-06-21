$ErrorActionPreference = "Stop"
$toolsdir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$url = 'https://proget.inedo.com/upack/Products/download/InedoReleases/DesktopHub/1.5.2?contentOnly=zip'
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
  Checksum      = '05525F860E00C13C378C46D50858D49B3ABEE2E575AF5FBAA519D3B3953A18D8'
  ChecksumType  = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs

#Set system path location for easy execution
Install-ChocolateyPath -Path $unzipLocation -PathType 'Machine'

# Write text file to document unzip location for use with uninstallation
Set-Content -Path (Join-Path $toolsdir -ChildPath 'uninstall.txt') -Value $unzipLocation

