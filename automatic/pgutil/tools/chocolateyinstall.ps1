$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.2.5.2/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = '4e5705c22fa760a10fc3b7bc6e86e6fb37a303d046b6b250492b23c20db24613'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
