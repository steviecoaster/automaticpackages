[cmdletBinding()]
param(
    [Parameter()]
    [Version]
    $DashboardVersion = $([string](Invoke-WebRequest -UseBasicParsing 'https://imsreleases.blob.core.windows.net/universal/production/version.txt')))

$currentVersion = choco list powershelluniversal --exact -r | ConvertFrom-CSV -Delimiter '|' -Header 'Name', 'Version'

if($null -eq $currentVersion) {
    $currentVersion = [pscustomobject]@{'Version' = '0.0.0'}
}
if ([version]$($currentVersion.Version) -lt $DashboardVersion) {
   
    $toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

    $Nuspec = Get-ChildItem $toolsDir -recurse -filter powershelluniversal.licensed.nuspec | Select-Object -ExpandProperty FullName

    (Get-Content "$Nuspec").Replace('[[VERSION]]', "$DashboardVersion") | Set-Content "$Nuspec"

    choco pack $Nuspec --output-directory="'$($env:Build_ArtifactStagingDirectory)'"
    choco push $((Get-ChildItem $env:Build_ArtifactStagingDirectory -filter powershelluniversal.licensed.*.nupkg).FullName) -s $env:UpstreamUrl --api-key="'$env:ChocoPushSecret'"
}