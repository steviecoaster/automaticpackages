$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.2.7.1/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = 'cb3f09551fd34c5020a4ac9490dd7f2d7c95a3a6b22e663c238ede2ef1d46f2c'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
