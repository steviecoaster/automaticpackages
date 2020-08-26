$latestrelease = (Invoke-RestMethod -Uri "https://api.github.com/repos/zulip/zulip-desktop/releases/latest").assets | 
    Where-Object { $_.name -match 'msi'}

$binary = $latestrelease.name
$null = $latestrelease.name -match '(?<version>\d+(\.\d+)+)'

$Version = $matches.version

$currentVersion = choco list zulip --exact -r -s https://chocolatey.org/api/v2| ConvertFrom-CSV -Delimiter '|' -Header 'Name', 'Version'

if($null -eq $currentVersion) {
    $currentVersion = [pscustomobject]@{'Version' = '0.0.0'}
}
if ([version]$($currentVersion.Version) -lt $Version) {
   
    $toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

    $Nuspec = Get-ChildItem $toolsDir -recurse -filter zulip.nuspec | Select-Object -ExpandProperty FullName
    $Install = Get-ChildItem $toolsDir -Recurse -Filter 'chocolateyInstall.ps1' | Where-Object { $_.FullName -contains 'zulip' } | Select-Object -ExpandProperty FullName 
    $Install

    $tempPath = Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid()).GUID
    New-item $tempPath -ItemType Directory
    Invoke-WebRequest -Uri $latestrelease.browser_download_url -OutFile "$TempDir\$binary"
    $checksum = ((Get-FileHash $TempDir\$binary).Hash).trim()

    (Get-Content "$Nuspec").Replace('[[VERSION]]', "$Version") | Set-Content "$Nuspec"
    (Get-Content "$Install").Replace('[[URL]]',"$($latestrelease.browser_download_url)")
    (Get-Content "$Install").Replace('[[CHECKSUM]]',"$checksum")

    choco pack $Nuspec --output-directory="'$($env:Build_ArtifactStagingDirectory)'"

    Get-ChildItem $env:Build_ArtifactStagingDirectory -filter *.nupkg
    #choco push $((Get-ChildItem $env:Build_ArtifactStagingDirectory -filter zulip.*.nupkg).FullName) -s https://push.chocolatey.org --api-key="'$env:ChocolateyKey'"
}