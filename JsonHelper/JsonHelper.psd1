@{
	# Module metadata
	ModuleVersion = '1.0.0'
	GUID = 'b2c3d4e5-f6a7-4b5c-9d0e-1f2a3b4c5d6e'
	Author = 'Peter Kaagman'
	CompanyName = 'Atlas College'
	Copyright = '(c) 2025 Peter Kaagman. Licensed under MIT License.'
	Description = 'Module for reading JSON files and converting them to PowerShell hashtables.'
	
	# Module components
	RootModule = 'JsonHelper.psm1'
	PowerShellVersion = '5.1'
	
	# Functions to export
	FunctionsToExport = @('Get-JsonAsHashtable', 'ConvertTo-Hashtable')
	
	# Cmdlets to export
	CmdletsToExport = @()
	
	# Variables to export
	VariablesToExport = @()
	
	# Aliases to export
	AliasesToExport = @()
	
	# Private data
	PrivateData = @{
		PSData = @{
			Tags = @('JSON', 'Hashtable', 'Conversion', 'Parser')
			ProjectUri = 'https://github.com/peter-kaagman/PS-Modules'
			ReleaseNotes = 'Initial release with Get-JsonAsHashtable and ConvertTo-Hashtable functions.'
		}
	}
}
