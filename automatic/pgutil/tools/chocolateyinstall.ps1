$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.2.9.1/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = '4b6796e71d43a2349e526a7cb2d91412f540296ae4bbce2436e51fa785b8fa2a'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
