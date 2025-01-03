$ErrorActionPreference = 'Stop'
$url64 = '' 
 
$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'exe'
    url64bit       = $url64
    checksum64     = '' 
    checksumType64 = 'sha256'   
    silentArgs     = "/qn /norestart /l*v '$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log'"
}

Install-ChocolateyPackage @packageArgs
