$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.1.10.2/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = 'f603281176349234a52626b875a994d49ec738f9dbad9a60f0f81c54fae50322'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
