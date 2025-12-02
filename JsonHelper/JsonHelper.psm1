function ConvertTo-Hashtable {
	<#
	.SYNOPSIS
	Converts a PSCustomObject to a Hashtable recursively.
	
	.DESCRIPTION
	Recursively converts PSCustomObject instances (typically from ConvertFrom-Json) 
	to hashtables, including nested objects and arrays.
	
	.PARAMETER InputObject
	The object to convert. Can be a PSCustomObject, array, or primitive type.
	
	.EXAMPLE
	$json = '{"name":"John","age":30}'
	$obj = $json | ConvertFrom-Json
	$hash = ConvertTo-Hashtable $obj
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory, ValueFromPipeline)]
		$InputObject
	)
	
	process {
		if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
			$collection = @()
			foreach ($item in $InputObject) {
				$collection += ConvertTo-Hashtable $item
			}
			return ,$collection
		}
		elseif ($InputObject -is [PSCustomObject]) {
			$hash = @{}
			foreach ($property in $InputObject.PSObject.Properties) {
				$hash[$property.Name] = ConvertTo-Hashtable $property.Value
			}
			return $hash
		}
		else {
			return $InputObject
		}
	}
}

function Get-JsonAsHashtable {
	<#
	.SYNOPSIS
	Reads a JSON file and returns its content as a hashtable.
	
	.DESCRIPTION
	Reads a JSON file, parses it, and converts the resulting PSCustomObject 
	to a hashtable structure. Supports nested objects and arrays.
	
	.PARAMETER Path
	The path to the JSON file to read.
	
	.PARAMETER Raw
	If specified, returns the content as-is without converting to hashtable.
	
	.EXAMPLE
	$config = Get-JsonAsHashtable -Path "C:\config.json"
	
	.EXAMPLE
	$data = Get-JsonAsHashtable "C:\data.json"
	Write-Host $data.settings.apiKey
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory, Position=0)]
		[string]$Path,
		
		[Parameter()]
		[switch]$Raw
	)
	
	if (-not (Test-Path $Path)) {
		throw "File not found: $Path"
	}
	
	try {
		$jsonContent = Get-Content -Path $Path -Raw -ErrorAction Stop
		$parsedJson = $jsonContent | ConvertFrom-Json -ErrorAction Stop
		
		if ($Raw) {
			return $parsedJson
		}
		
		return ConvertTo-Hashtable $parsedJson
	}
	catch {
		throw "Error reading or parsing JSON file: $_"
	}
}

Export-ModuleMember -Function Get-JsonAsHashtable, ConvertTo-Hashtable
