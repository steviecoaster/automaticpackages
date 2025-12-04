$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url = 'https://github.com/Inedo/pgutil/releases/download/v2.2.1.1/pgutil-win-x64.zip'

$zipArgs = @{
  PackageName = $env:ChocolateyPackageName
  Url = $url
  UnzipLocation = $toolsDir
  checksum = '94565db6a754609aa5fbdfb1b51f88a37fae047f91691d10bfebd9942c8fa48d'
  checksumType = 'SHA256'
}

Install-ChocolateyZipPackage @zipArgs
