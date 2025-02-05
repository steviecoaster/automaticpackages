$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.1.1.3/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = '1f55a1a5061a93569558906bc326a055c72dbffca8ae3591b3e2aee0a20fa48f'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
