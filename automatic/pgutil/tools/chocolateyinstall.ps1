$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = ''

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  Checksum = ''
  ChecksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
