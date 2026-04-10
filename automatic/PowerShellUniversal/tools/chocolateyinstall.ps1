
$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://imsreleases.blob.core.windows.net/universal/production/2026.1.6/PowerShellUniversal.2026.1.6.msi'

$pp = Get-PackageParameters

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  softwareName  = 'PowerShellUniversal*'
  checksum      = '8B7AB4AD0DE74215210DA072DB21DD10798BEFE52333692E49946EEAF2596811'
  checksumType  = 'sha256'
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`" SUPPRESSBROWSER=true"
  validExitCodes= @(0, 3010, 1641)
}

if($pp['OpenBrowserOnInstall']){
  $packageArgs.silentArgs = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
}

# To ensure upgrades go smoothly, we ensure the database will be upgraded.
# For further details, see: https://forums.ironmansoftware.com/t/upgrade-from-1-5-13-to-2-1-0-now-failing-to-start/5183/4
if (-not $pp.SkipDatabaseUpgrade) {
  $AppSettingsPath = (Get-Item "${env:ProgramFiles}*\Universal\appsettings.json").FullName
  if ($AppSettingsPath) {
    $AppSettings = Get-Content -Path $AppSettingsPath | ConvertFrom-Json

    if ($AppSettings.Data.ConnectionString -notmatch "(^|;)upgrade=true(;|$)") {
      $AppSettings.Data.ConnectionString = $AppSettings.Data.ConnectionString.TrimEnd(';') + ";upgrade=true"
      $AppSettings | ConvertTo-Json | Set-Content $AppSettingsPath
    }
  }
}

Install-ChocolateyPackage @packageArgs
