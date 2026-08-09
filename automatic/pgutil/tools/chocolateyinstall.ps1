$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.4.1.1/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = 'a350f5be5212d496beb03bb95386ba91eee4d07beb84a5008d72cdce72a98125'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
