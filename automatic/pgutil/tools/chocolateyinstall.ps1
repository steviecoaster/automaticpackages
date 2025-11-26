$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.2.0.3/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = 'f2abf24a00ae29265b469f96d78a6cfced17eaa7c3c78592f92c9bee436ee66c'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
