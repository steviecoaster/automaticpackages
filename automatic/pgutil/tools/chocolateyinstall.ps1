$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.0.6.1/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = '3526db5cda754570e99f4edc75e8a82d81596f54b55786a23bfbbcca5f6cf95e'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
