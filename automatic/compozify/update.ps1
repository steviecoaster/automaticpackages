Import-Module Chocolatey-AU

function global:au_GetLatest {
    $LatestRelease = Invoke-RestMethod -UseBasicParsing -Uri "https://api.github.com/repos/profclems/compozify/releases/latest"

    @{
        URL64   = ($LatestRelease.assets | Where-Object { $_.name -eq 'compozify_0.2.1_windows_amd64.zip' }).browser_download_url
        Version = ($LatestRelease.tag_name).TrimStart('v')
    }
}
 
function global:au_SearchReplace {
    @{
        ".\tools\chocolateyinstall.ps1" = @{
            "(?i)(^\s*(\$)url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
            #"(?i)(^\s*checksum64\s*=\s*)('.*')"       = { "$1'$($Latest.Checksum64)'" }
        }

    }
}

update -ChecksumFor 64