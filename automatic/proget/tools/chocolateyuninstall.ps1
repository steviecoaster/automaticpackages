$ErrorActionPreference = 'Stop' # stop on all errors

#Set the location of hub.exe for command execution
$fileLocation = (Get-Command hub.exe).source

$installArgs = @("uninstall","ProGet")

$Statements = $installArgs -Join " "

Start-ChocolateyProcessAsAdmin -Statements $Statements -ExeToRun $fileLocation