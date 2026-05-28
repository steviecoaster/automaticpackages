Import-Module Chocolatey-AU

#Create a temp dir
$tempDir = New-Item -Path $env:TEMP -Name (New-Guid).Guid -ItemType Directory
$fondue = Join-Path $tempDir -ChildPath 'Fondue'
$zipFile = Join-Path $tempDir -ChildPath 'Fondue.zip'

Save-Module -Name Fondue -Path $tempDir -Repository PSGallery
Compress-Archive -Path $fondue -DestinationPath $zipFile

$toolsDir = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) -ChildPath 'tools'

Copy-Item $zipFile -Destination $toolsDir -Force

Remove-Item $tempDir -Recurse -Force
function global:au_GetLatest {
    $LatestRelease = Find-Module Fondue -Repository PSGallery

    @{
        Version = $LatestRelease.Version
    }
}

update -ChecksumFor none -NoCheckChocoVersion