$ErrorActionPreference = 'Stop' # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64 = 'https://github.com/justin025/onthespot/releases/download/v1.0.7/OnTheSpot-1.0.7-x86_64.exe'
$file = Split-Path -Leaf $url64
$fileLocation = Join-path $toolsDir -ChildPath $file
$pp = Get-PackageParameters

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileFullPath   = $fileLocation
  url64          = $url64
  checksum64     = '6271ac871d0943d981cdb0fdb445957632f98f9fd3aca89491de6421f69b6568'
  checksumType64 = 'SHA256' 
}

Get-ChocolateyWebFile @packageArgs

if ($pp['AddDesktopShortcut']) {
  $binFolder = Join-Path $env:ChocolateyInstall -ChildPath 'bin'
  $shim = Join-Path $binFolder -ChildPath $file
  $publicDesktop = Join-Path $env:PUBLIC -ChildPath 'Desktop'
  $shorcutLink = Join-Path $publicDesktop -ChildPath 'OnTheSpot.lnk'
  Install-ChocolateyShortcut -ShortcutFilePath $shorcutLink -TargetPath $shim
  Write-Output 'Previous warning can be ignored, explorer just needs refreshed'

  # Write shortcut link to file for uninstall script to pick up
  $remove = Join-Path $toolsDir -ChildPath 'removeShortcut.txt'
  $shorcutLink | Set-Content $remove
}
