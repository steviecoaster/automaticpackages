# Put inverse code from install here
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$file = Join-Path $toolsDir -ChildPath 'removeShortcut.txt'

if (Test-Path $file) {
    $shortcut = Get-Content $file
    Remove-Item -LiteralPath $shortcut -Force
}
