$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.2.10.1/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = '82b9dc4d93d7ee6f0d2067d890b850aa4338ef2f2289ff1805faa11f32444153'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
