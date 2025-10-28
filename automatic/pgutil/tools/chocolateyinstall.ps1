$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.1.16.1/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = 'c693666278c81b9f3333ed14e58ae87912dafac0a0f7b0d863dc9d7b30abbf5d'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
