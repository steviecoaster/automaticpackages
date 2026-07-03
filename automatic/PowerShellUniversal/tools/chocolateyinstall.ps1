
$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://imsreleases.blob.core.windows.net/universal/production/2026.2.2/PowerShellUniversal.2026.2.2.msi'

$pp = Get-PackageParameters

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  softwareName  = 'PowerShellUniversal*'
  checksum      = '7C865D7D634F41532A019EF4D06E45DE56E9E18B7B0F229358F2A53890AA8E2A'
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
