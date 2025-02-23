$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.1.2.1/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = '5d3d2d71d859735e95387dd64c8fcb054bc16fb28d9a66f7c24803d5cc2f9d0e'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
