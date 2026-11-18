$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.4.6.2/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = '1625d309d6adfc1cf5b3e8167766bda891dba2dd2937d8a8d1c04f7561ee0fe9'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
