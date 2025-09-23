Import-Module Chocolatey-AU

function global:au_BeforeUpdate() {
    $Latest.Checksum64 = Get-RemoteChecksum $Latest.URL64
}

function global:au_GetLatest {
    $LatestRelease = Invoke-RestMethod -UseBasicParsing -Uri "https://api.github.com/repos/automatedlab/automatedlab/releases/latest"

    @{
        URL64   = ($LatestRelease.assets | Where-Object { $_.name -eq "automatedlab.msi" }).browser_download_url
        Version = $LatestRelease.tag_name
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

update -ChecksumFor none -NoCheckChocoVersion