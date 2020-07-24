[cmdletBinding()]
param(
    [Parameter()]
    [Version]
    $DashboardVersion = $([string](Invoke-WebRequest -UseBasicParsing 'https://imsreleases.blob.core.windows.net/universal/production/version.txt')),
    [Parameter()]
    [String]
    $DashboardDownloadPath = "https://imsreleases.blob.core.windows.net/universal/production/$dashboardVersion/PowerShellUniversal.$dashboardVersion.msi"
    )

    $tempPath = Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid()).GUID
    $null = New-Item $tempPath -ItemType Directory

    $UniversalPath = Join-Path $tempPath $("PowerShellUniversal.$DashboardVersion.msi")

    $downloader = [System.net.WebClient]::new()
    $downloader.DownloadFile($DashboardDownloadPath,$UniversalPath)

    $checksum = (Get-FileHash $UniversalPath).Hash

    Remove-Item $tempPath -Recurse -Force

    (Get-Content 'C:\tmp\Universal\PowerShellUniversal\tools\chocolateyinstall.ps1').Replace('[[URL]]',"$DashboardDownloadPath") | Set-Content 'C:\tmp\Universal\PowerShellUniversal\tools\chocolateyinstall.ps1'
    (Get-Content 'C:\tmp\Universal\PowerShellUniversal\tools\chocolateyinstall.ps1').Replace('[[CHECKSUM]]',"$checksum") | Set-Content 'C:\tmp\Universal\PowerShellUniversal\tools\chocolateyinstall.ps1'
    (Get-Content 'C:\tmp\Universal\PowerShellUniversal\powershelluniversal.nuspec').Replace('[[VERSION]]',"$DashboardVersion") | Set-Content 'C:\tmp\Universal\PowerShellUniversal\powershelluniversal.nuspec'

