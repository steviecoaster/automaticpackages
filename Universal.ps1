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
    $Checksum = $([string](Invoke-WebRequest"https://imsreleases.blob.core.windows.net/universal/production/$dashboardVersion/PowerShellUniversal.$dashboardVersion.msi.sha256"))
)

$currentVersion = choco list powershelluniversal --exact -r | ConvertFrom-CSV -Delimiter '|' -Header 'Name', 'Version'

if($null -eq $currentVersion) {
    $currentVersion = [pscustomobject]@{'Version' = '0.0.0'}
}
if ([version]$($currentVersion.Version) -lt $DashboardVersion) {
   
    $toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

    $Nuspec = Get-ChildItem $toolsDir -recurse -filter *.nuspec | Select-Object -ExpandProperty FullName
    $Install = Get-ChildItem $toolsDir -Recurse -Filter 'chocolateyInstall.ps1' | Select-Object -ExpandProperty FullName

    (Get-Content "$Install").Replace('[[URL]]', "$DashboardDownloadPath") | Set-Content "$Install"
    (Get-Content "$Install").Replace('[[CHECKSUM]]', "$Checksum") | Set-Content "$Install"
    (Get-Content "$Nuspec").Replace('[[VERSION]]', "$DashboardVersion") | Set-Content "$Nuspec"

    choco pack $Nuspec --output-directory="'$($env:Build_ArtifactStagingDirectory)'"
    choco push $((Get-ChildItem $env:Build_ArtifactStagingDirectory -filter *.nupkg).FullName) -s https://push.chocolatey.org --api-key="'$env:ChocolateyKey'"
}