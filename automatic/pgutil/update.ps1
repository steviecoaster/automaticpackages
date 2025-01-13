Import-Module Chocolatey-AU

function global:au_GetLatest {
    $LatestRelease = Invoke-RestMethod -UseBasicParsing -Uri "https://api.github.com/repos/inedo/pgutil/releases/latest"

    @{
        URL   = ($LatestRelease.assets | Where-Object { $_.name -eq 'pgutil-win-x64.zip' }).browser_download_url
        Version = $LatestRelease.tag_name.TrimStart('v')
    }
}
 
function global:au_SearchReplace {
    @{
        ".\tools\chocolateyinstall.ps1" = @{
            "(?i)(^\s*(\$)url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            #"(?i)(^\s*checksum64\s*=\s*)('.*')"       = { "$1'$($Latest.Checksum64)'" }
        }

    }
}

update -ChecksumFor 32 -NoCheckChocoVersion