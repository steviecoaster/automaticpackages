$ErrorActionPreference = 'Stop'

# Determine unzipLocation
$toolsdir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$txtfile = Join-Path $toolsdir -ChildPath 'uninstall.txt'
$unzipLocation = Get-Content $txtfile

#Remove hub.exe from the system path
Uninstall-ChocolateyPath -Path $unzipLocation -PathType 'Machine'

#Remove the location where InedoHub was unzipped
Remove-Item $unzipLocation -Recurse -Force
