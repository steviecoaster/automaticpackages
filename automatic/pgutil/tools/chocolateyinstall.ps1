$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.1.11.6/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = '5240f09d673437258d7ff1133afeaa3513d305a30afb6dad746e0192cab82724'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
