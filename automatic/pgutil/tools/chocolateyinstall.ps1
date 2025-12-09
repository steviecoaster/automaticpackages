$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.2.3.1/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = '6b32b5cf739c9b70facc5406dc95af5cc8665b6a8a93f5c04615c9a2580e069b'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
