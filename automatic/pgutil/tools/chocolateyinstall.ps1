$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.1.4.1/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = 'eb62266855ee009dac588956861c1534f97a8b4ee7fa860c96c4fc7d84f76458'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
