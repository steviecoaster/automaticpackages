Import-Module Chocolatey-AU

function global:au_GetLatest {
    $LatestRelease = Invoke-RestMethod -UseBasicParsing -Uri "https://api.github.com/repos/justin025/onthespot/releases/latest"
    @{
        URL64   = ($LatestRelease.assets | Where-Object { $_.name -eq 'OnTheSpot-1.0.7-x86_64.exe' }).browser_download_url
        Version = ($LatestRelease.tag_name).TrimStart('v') 
    }
}
 
function global:au_SearchReplace {
    @{
        ".\tools\chocolateyinstall.ps1" = @{
            "(?i)(^\s*(\$)url64\s*=\s*)('.*')"  = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            #"(?i)(^\s*checksum32\s*=\s*)('.*')"       = { "$1'$($Latest.Checksum)'" } # May need this if 32-bit & 64-bit
        }

    }
}

update -ChecksumFor 64