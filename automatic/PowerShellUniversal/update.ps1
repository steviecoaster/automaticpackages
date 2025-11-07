Import-Module Chocolatey-AU

function global:au_GetLatest {
    $LatestVersion = Invoke-RestMethod https://imsreleases.blob.core.windows.net/universal/production/v5-version.txt

    @{
        Version  = $LatestVersion
        URL      = "https://imsreleases.blob.core.windows.net/universal/production/$LatestVersion/PowerShellUniversal.$LatestVersion.msi"
        Checksum = Invoke-RestMethod -UseBasicParsing "https://imsreleases.blob.core.windows.net/universal/production/$LatestVersion/PowerShellUniversal.$LatestVersion.msi.sha256"
    }
}

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyinstall.ps1" = @{
            "(?i)(^\s*(\$)url\s*=\s*)('.*')"  = "`$1'$($Latest.URL)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum)'"
        }
    }
}

update -ChecksumFor none -NoCheckChocoVersion -Verbose