Import-Module Chocolatey-AU

function global:au_BeforeUpdate() {
    $Latest.Checksum64 = Get-RemoteChecksum $Latest.URL64
}

function global:au_GetLatest {
    $LatestRelease = Invoke-RestMethod -UseBasicParsing -Uri "https://api.github.com/repos/Devolutions/jiffshot/releases/latest"
    $Version = $LatestRelease.tag_name.TrimStart('v')
    $AssetName = 'Devolutions.Jiffshot-windows-x64-{0}.msi' -f $Version
    $Asset = $LatestRelease.assets | Where-Object { $_.name -eq $AssetName } | Select-Object -First 1

    if (-not $Asset -or -not $Asset.browser_download_url) {
        throw "Could not find release asset '$AssetName' in the latest Jiffshot release."
    }
    
    @{
        URL64   = $Asset.browser_download_url
        Version = $Version
    }
}
 
function global:au_SearchReplace {
    @{
        ".\tools\chocolateyinstall.ps1" = @{
            "(?i)(^\s*(\$)url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
        }

    }
}

update -ChecksumFor none -NoCheckChocoVersion