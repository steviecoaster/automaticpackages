$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.2.2.1/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = '6caf8074c50e467c1af0d3bb3d2a519c33d769400ba17446b2eae39d8272d0c4'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
