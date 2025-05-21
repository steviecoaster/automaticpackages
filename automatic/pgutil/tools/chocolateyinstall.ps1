$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.1.9.1/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = '5b2618b14fe738b976ab8261ae48481ec20cc9033390747772a1a7805c27e88c'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
