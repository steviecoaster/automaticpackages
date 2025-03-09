$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.1.3.1/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = 'f51be1c47c00b5163ead7bae88dd9eeda854fb574e2c871f6a046b1fd00dd7e2'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
