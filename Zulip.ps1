
Write-Host "Fetching latest release information from Github"
$latestrelease = (Invoke-RestMethod -Uri "https://api.github.com/repos/zulip/zulip-desktop/releases/latest").assets | 
    Where-Object { $_.name -match 'msi'}

    $binary = $latestrelease.name
$null = $latestrelease.name -match '(?<version>\d+(\.\d+)+)'
$Version = $matches.version

Write-Host "Found release for: $binary"
Write-Host "Version set to: $Version"

$currentVersion = choco list zulip --exact -r -s https://chocolatey.org/api/v2| ConvertFrom-CSV -Delimiter '|' -Header 'Name', 'Version'

if($null -eq $currentVersion) {
    $currentVersion = [pscustomobject]@{'Version' = '0.0.0'}
}
if ([version]$($currentVersion.Version) -lt $Version) {
   
    $toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

    $Nuspec = Get-ChildItem $toolsDir -recurse -filter zulip.nuspec | Select-Object -ExpandProperty FullName
    $Install = Get-ChildItem $toolsDir -Recurse -Filter 'chocolateyInstall.ps1' | Where-Object { $_.Directory -match 'zulip' } | Select-Object -ExpandProperty FullName 
    
    Write-Host "Install Script: $Install"

    $tempPath = Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid()).GUID
    Write-Host "Creating temp directory: $tempPath"
    $null = New-item $tempPath -ItemType Directory
    
    Write-Host "Generating checksum for binary"
    $downloader = New-Object System.Net.WebClient
    $downloader.DownloadFile($($latestrelease.browser_download_url),"$tempPath\$binary")
    #Invoke-WebRequest -Uri $latestrelease.browser_download_url -OutFile "$tempPath\$binary"
    $checksum = ((Get-FileHash $TempPath\$binary).Hash).trim()

    Write-Host "Generated checksum: $checksum"

    Write-Host "Replacing content in files"
    (Get-Content "$Nuspec").Replace('[[VERSION]]', "$Version") | Set-Content "$Nuspec"
    (Get-Content "$Install").Replace('[[URL]]',"$($latestrelease.browser_download_url)") | Set-Content "$Install"
    (Get-Content "$Install").Replace('[[CHECKSUM]]',"$checksum") | Set-Content "$Install"

    Write-Host "Verify install script contents"
    Get-Content $Install

    Write-Host "Packing the package"
    choco pack $Nuspec --output-directory="'$($env:Build_ArtifactStagingDirectory)'"

    Write-host "Validate nupkg is correct"
    Get-ChildItem $env:Build_ArtifactStagingDirectory -filter *.nupkg
    choco push $((Get-ChildItem $env:Build_ArtifactStagingDirectory -filter zulip.*.nupkg).FullName) -s $env:UpstreamUrl --api-key="'$env:ChocoPushSecret'"
}