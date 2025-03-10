BeforeDiscovery {
  $script:packages = Get-ChildItem -Path $PSScriptRoot\..\automatic -Directory
}
Describe 'Update File <_.Name>' -ForEach $script:packages {
  BeforeAll {
    $script:UpdateFile = Join-Path -Path $_.FullName -ChildPath 'Update.ps1'
    $Tokens = $null
    $Errors = $null
    $script:ast = [System.Management.Automation.Language.Parser]::ParseFile(
      $script:UpdateFile,
      [ref]$Tokens,
      [ref]$Errors
    )
  }

  It 'Update file exists' {
    $script:UpdateFile | Should -Exist
  }

  Context 'File encoding' {
    It "No update file uses Unicode/UTF-16 encoding" {
      $script:UpdateFile | Test-FileUnicode | Should -Be $false
    }
  }
  
  It "Import Chocolatey-AU module" {
    Get-Content $script:UpdateFile | Select-String -Pattern 'Import-Module Chocolatey-AU'
  }

  It 'has function au_GetLatest' {
    $script:ast.FindAll(
      {
        param($Ast)
        $Ast -is [System.Management.Automation.Language.FunctionDefinitionAst] -and
        $Ast.Name -eq 'global:au_GetLatest'
      },
      $false
    ) | Should -Not -BeNullOrEmpty
  }

  It 'calls the update function' {
    $script:ast.FindAll(
      {
        param($Ast)
        $Ast -is [System.Management.Automation.Language.CommandAst] -and
        $Ast.CommandElements[0].Value -eq 'update'
      },
      $false
    ) | Should -Not -BeNullOrEmpty
  }
}