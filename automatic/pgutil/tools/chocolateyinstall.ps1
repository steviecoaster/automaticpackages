$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.4.0.2/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = 'ab649e6e16ac1679bff3bfcd0a9e266bc05f086d9e89d72e3b74a61385cece07'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
