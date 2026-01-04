$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.2.4.4/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = '3769f707d7d36aee44dab5d48a5fad5f1bdbc7a9eaaa88cc90e4a66f57f4aa62'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
