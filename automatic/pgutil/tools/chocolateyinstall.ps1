$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.1.15.1/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = 'ffca588fb64a07e29ae04853fbe5bfc279109dfd59311142a2265c47e3a67123'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
