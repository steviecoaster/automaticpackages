Import-Module Chocolatey-AU
function Copy-Module {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]
        $Version
    )

    $toolsDir = Join-Path $PSScriptRoot -ChildPath 'tools'
    $tempDir = New-Item (Join-Path $env:TEMP -ChildPath (New-Guid).Guid) -ItemType Directory

    Save-Module -Name Posh-Acme -RequiredVersion $Version -Path $tempDir
    Compress-Archive "$tempDir\Posh-ACME*" -DestinationPath "$toolsDir\Posh-Acme.zip"



}
function global:au_GetLatest {
    $LatestRelease = Invoke-RestMethod -UseBasicParsing -Uri "https://api.github.com/repos/rmbolger/Posh-Acme/releases/latest"
    Copy-Module -Version $LatestRelease.tag_name.TrimStart('v')

    @{
        Version = $LatestRelease.tag_name.TrimStart('v')
    }
}

function global:au_SearchReplace {}

update -ChecksumFor none -NoCheckChocoVersion