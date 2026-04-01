$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.2.6.1/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = '7ec7b2ab6b3af02d2a54895300d844ed6577192edcc282ecbc076f9fe1afaf63'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
