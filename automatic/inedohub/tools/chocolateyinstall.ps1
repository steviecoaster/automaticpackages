$ErrorActionPreference = "Stop"
$toolsdir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$url = 'https://proget.inedo.com/upack/Products/download/InedoReleases/DesktopHub/1.5.4?contentOnly=zip'
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
  Checksum      = '7F475277AC6F73C03BB37789FD028F77524CCD4CB261AD9520222F94103FC990'
  ChecksumType  = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs

#Set system path location for easy execution
Install-ChocolateyPath -Path $unzipLocation -PathType 'Machine'

# Write text file to document unzip location for use with uninstallation
Set-Content -Path (Join-Path $toolsdir -ChildPath 'uninstall.txt') -Value $unzipLocation

