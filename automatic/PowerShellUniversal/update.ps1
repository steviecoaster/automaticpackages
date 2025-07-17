Import-Module Chocolatey-AU

function global:au_GetLatest {
    $LatestVersion = $(
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
    )[0]

    @{
        Version  = $LatestVersion
        URL      = "https://imsreleases.blob.core.windows.net/universal/production/$LatestVersion/PowerShellUniversal.$LatestVersion.msi"
        Checksum = "$([string](Invoke-WebRequest -UseBasicParsing "https://imsreleases.blob.core.windows.net/universal/production/$LatestVersion/PowerShellUniversal.$LatestVersion.msi.sha256"))".Trim()
    }
}

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyinstall.ps1" = @{
            "(?i)(^\s*(\$)url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum)'"
        }
    }
}

update -ChecksumFor none -NoCheckChocoVersion
