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