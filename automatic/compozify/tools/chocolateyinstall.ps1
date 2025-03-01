$ErrorActionPreference = 'Stop' # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64 = 'https://github.com/profclems/compozify/releases/download/v0.2.1/compozify_0.2.1_windows_amd64.zip'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  url64          = $url64
  checksum64     = '79354775cac53066c09c94d5eb189bb3d93229f671a6a5ae5d51db14feb777bc'
  checksumType64 = 'SHA256'
  unzipLocation = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs
