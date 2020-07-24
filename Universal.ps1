[cmdletBinding()]
param(
    [Parameter()]
    [Version]
    $DashboardVersion = $([string](Invoke-WebRequest -UseBasicParsing 'https://imsreleases.blob.core.windows.net/universal/production/version.txt')),
    [Parameter()]
    [String]
    $DashboardDownloadPath = "https://imsreleases.blob.core.windows.net/universal/production/$dashboardVersion/PowerShellUniversal.$dashboardVersion.msi"
    )

    $toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

    $Nuspec = Get-ChildItem $toolsDir -recurse -filter *.nuspec | Select -ExpandProperty FullName
    $Install = Get-ChildItem $toolsDir -Recurse -Filter 'chocolateyInstall.ps1' | Select -ExpandProperty FullName


    $tempPath = Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid()).GUID
    $null = New-Item $tempPath -ItemType Directory

    $UniversalPath = Join-Path $tempPath $("PowerShellUniversal.$DashboardVersion.msi")

    $downloader = [System.net.WebClient]::new()
    $downloader.DownloadFile($DashboardDownloadPath,$UniversalPath)

    $checksum = (Get-FileHash $UniversalPath).Hash

    Remove-Item $tempPath -Recurse -Force

    (Get-Content "$Install").Replace('[[URL]]',"$DashboardDownloadPath") | Set-Content "$Install"
    (Get-Content "$Install").Replace('[[CHECKSUM]]',"$checksum") | Set-Content "$Install"
    (Get-Content "$Nuspec").Replace('[[VERSION]]',"$DashboardVersion") | Set-Content "$Nuspec"

    choco pack $Nuspec --output-directory="'$($env:Build_ArtifactStagingDirectory)'"

    Get-ChildItem $env:Build_ArtifactStagingDirectory -filter *.nupkg