@{
	# Module metadata
	ModuleVersion = '1.0.0'
	GUID = 'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d'
	Author = 'Peter Kaagman'
	CompanyName = 'Atlas College'
	Copyright = '(c) 2025 Peter Kaagman. Licensed under MIT License.'
	Description = 'Module for testing conditions against nested hashtable structures and retrieving values from them.'
	
	# Module components
	RootModule = 'StructMatcher.psm1'
	PowerShellVersion = '5.1'
	
	# Functions to export
	FunctionsToExport = @('Test-ConditionSet')
	
	# Cmdlets to export
	CmdletsToExport = @()
	
	# Variables to export
	VariablesToExport = @()
	
	# Aliases to export
	AliasesToExport = @()
	
	# Private data
	PrivateData = @{
		PSData = @{
			Tags = @('Hashtable', 'Conditions', 'Testing', 'Structure')
			ProjectUri = 'https://github.com/peter-kaagman/Atlas-HelloID-Scripts'
			ReleaseNotes = 'Initial release with Get-InfoFromStruct and Test-ConditionSet functions.'
		}
	}
}
