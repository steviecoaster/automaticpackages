$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$Nuspec = Get-ChildItem $toolsDir -recurse -filter *.nuspec | Select -ExpandProperty FullName
$Install = Get-ChildItem $toolsDir -Recurse -Filter 'chocolateyInstall.ps1' | Select -ExpandProperty FullName

$Nuspec
$Install