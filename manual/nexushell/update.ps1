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

    Save-Module -Name NexuShell -RequiredVersion $Version -Path $tempDir
    Compress-Archive "$tempDir\Nexus*" -DestinationPath "$toolsDir\NexuShell.zip"



}
function global:au_GetLatest {
    $LatestRelease = Invoke-RestMethod -UseBasicParsing -Uri "https://api.github.com/repos/steviecoaster/nexushell/releases/latest"
    Copy-Module -Version $LatestRelease.tag_name

    @{
        Version = $LatestRelease.tag_name.TrimStart('v')
    }
}

function global:au_SearchReplace {}

update -ChecksumFor none -NoCheckChocoVersion