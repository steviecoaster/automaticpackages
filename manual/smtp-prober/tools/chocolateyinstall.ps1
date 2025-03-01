$ErrorActionPreference = 'Stop' # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'http://www.alexnolan.net/software/SMTPProber.exe' # download url, HTTPS preferred
$filename = Split-Path $url -Leaf
$fileFullPath = Join-Path $toolsDir -ChildPath $filename

$webfileArgs = @{
  PackageName = $env:ChocolateyPackageName
  FileFullPath = $fileFullPath
  Url = $url
  checksum = '2AC96F9159E965BBE3A88784168577D65E4605234B13A085DDB612AD88DC86B8'
  checksumType = 'SHA256'
}

Get-ChocolateyWebFile @webfileArgs
