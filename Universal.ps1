[cmdletBinding()]
param(
    [Parameter()]
    [Version]
    $DashboardVersion = $([string](Invoke-WebRequest -UseBasicParsing 'https://imsreleases.blob.core.windows.net/universal/production/version.txt')),

    [Parameter()]
    [String]
    $DashboardDownloadPath = "https://imsreleases.blob.core.windows.net/universal/production/$dashboardVersion/PowerShellUniversal.$dashboardVersion.msi",

    [Parameter()]
    [string]
    $Checksum = $([string](Invoke-WebRequest -UseBasicParsing "https://imsreleases.blob.core.windows.net/universal/production/$dashboardVersion/PowerShellUniversal.$dashboardVersion.msi.sha256"))
)

$currentVersion = choco list powershelluniversal --exact -r | ConvertFrom-CSV -Delimiter '|' -Header 'Name', 'Version'

if($null -eq $currentVersion) {
    $currentVersion = [pscustomobject]@{'Version' = '0.0.0'}
}
if ([version]$($currentVersion.Version) -lt $DashboardVersion) {
   
    $toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

    $Nuspec = Get-ChildItem $toolsDir -recurse -filter powershelluniversal.nuspec | Select-Object -ExpandProperty FullName
    $Install = Get-ChildItem $toolsDir -Recurse -Filter 'chocolateyInstall.ps1' | Where-Object { $_.Directory -notmatch 'nexus-repository|powershelluniversal.licensed|zulip' } | Select-Object -ExpandProperty FullName

    (Get-Content "$Install").Replace('[[URL]]', "$DashboardDownloadPath") | Set-Content "$Install"
    (Get-Content "$Install").Replace('[[CHECKSUM]]', "$($Checksum.Trim())") | Set-Content "$Install"
    (Get-Content "$Nuspec").Replace('[[VERSION]]', "$DashboardVersion") | Set-Content "$Nuspec"

    choco pack $Nuspec --output-directory="'$toolsDir'"
    choco push $((Get-ChildItem $toolsDir -filter powrshelluniversal.*.nupkg).FullName) -s https://push.chocolatey.org --api-key="'$env:CHOCO_API_KEY'"
}