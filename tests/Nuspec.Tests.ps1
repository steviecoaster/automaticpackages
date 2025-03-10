BeforeDiscovery {
  $script:specs = Get-ChildItem -Path $PSScriptRoot\..\ -Recurse -Filter "*.nuspec"
}
BeforeAll {
  Import-Module -Name $PSScriptRoot\MetaFixers.psm1
}
Describe 'Nuspec File <_.Name>' -ForEach $script:specs {
  # Validate that the encoding is correct
  Context 'File encoding' {
    It "No nuspec file uses Unicode/UTF-16 encoding" {
      $_ | Test-FileUnicode | Should -Be $false
    }
  }

  # Validate that the file is well-formed XML
  Context 'XML' {
    BeforeAll {
      $script:xml = [xml](Get-Content -Path $_.FullName)
    }
    It "Nuspec file is well-formed XML" {
      
      $script:xml | Should -Not -BeNullOrEmpty
    }

    # Make sure id matches the xml id
    It "Nuspec file id matches the xml id" {
      $filename = $_.BaseName.ToLower()
      $xml.package.metadata.id | Should -Be $filename
    }

    It 'ID should be lower case' {
      $xml.package.metadata.id | Should -Be $xml.package.metadata.id.ToLower()
    }
  }
}