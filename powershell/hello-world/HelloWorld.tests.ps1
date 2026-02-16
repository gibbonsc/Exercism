BeforeAll {
. (Join-Path -Path $PSScriptRoot -ChildPath 'HelloWorld.ps1')
}

Describe "HelloWorldTest" {
	It "Outputs: 'Hello, World!'" {
		Get-HelloWorld | Should -Be 'Hello, World!'
	}
}
