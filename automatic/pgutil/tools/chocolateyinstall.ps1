$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.3.0.1/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = '72734eb74203109aed697e2ba5f700bf36a3777a3d881649061e129f0454437b'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
