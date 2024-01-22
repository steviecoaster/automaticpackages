[CmdletBinding()]
param(
    [Parameter()]
    [Version]
    $DashboardVersion = $(
        (Invoke-WebRequest https://ironmansoftware.com/release/powershell-universal -UseBasicParsing).Links.href.Where{
            # Get any download URL with an MSI, as we're not interested in theoretical releases without it.
            # Also, ignore the EventHubClient installers, as it's not a part of this package.
            $_.EndsWith('.msi') -and $_ -notmatch "\.EventHubClient\."
        }.ForEach{
            # Get the version "folder" from the URL, as in $DashboardDownloadPath below.
            $_.Split('/')[-2]
        } | Sort-Object {
            # Prerelease versions will fall to the bottom, as [version] does not support them.
            # This is okay, because the package currently only publishes production versions.
            $_ -as [version]
        } -Descending
    )[0],

    [Parameter()]
    [String]
    $DashboardDownloadPath = "https://imsreleases.blob.core.windows.net/universal/production/$DashboardVersion/PowerShellUniversal.$DashboardVersion.msi",

    [Parameter()]
    [string]
    $Checksum = $([string](Invoke-WebRequest -UseBasicParsing "https://imsreleases.blob.core.windows.net/universal/production/$DashboardVersion/PowerShellUniversal.$DashboardVersion.msi.sha256"))
)

$currentVersion = choco search powershelluniversal --source https://community.chocolatey.org/api/v2/ --exact -r | ConvertFrom-CSV -Delimiter '|' -Header 'Name', 'Version'

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
    choco push $((Get-ChildItem $toolsDir -Filter powershelluniversal.*.nupkg).FullName) -s $env:UpstreamUrl --api-key="'$env:ChocoPushSecret'"
}