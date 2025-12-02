function Get-InfoFromStruct {
	<#
	.SYNOPSIS
	Retrieves a value from a nested hashtable structure.
	
	.DESCRIPTION
	Navigates through a hashtable structure using an array of property names (levels)
	and returns the value at the final level.
	
	.PARAMETER levels
	Array of property names representing the path through the hashtable structure.
	
	.PARAMETER data
	The hashtable or object to navigate through.
	
	.EXAMPLE
	Get-InfoFromStruct -levels @("person", "PrimaryContract", "Location") -data $myData
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[array] $levels,

		[Parameter(Mandatory)]
		$data
	)
	
	try {
		Write-Verbose "Navigating path: $($levels -join ' -> ')"
		foreach ($level in $levels) {
			if ($null -eq $data) {
				throw "Path not found: null value encountered at level '$level'"
			}
			$data = $data.$level
		}
		return $data
	}
	catch {
		Write-Warning "Error navigating structure: $_"
		return $null
	}
}

function Test-ConditionSet {
	<#
	.SYNOPSIS
	Tests multiple conditions against a hashtable structure.
	
	.DESCRIPTION
	Evaluates a set of conditions against a data structure. All conditions must be met
	(AND logic) for the test to pass. If all conditions are met, returns the specified result.
	
	.PARAMETER rules
	Hashtable containing:
	- conditions: Array of condition objects with properties: level, operator, check
	- result: String or array specifying what to return when all conditions are met
	
	.PARAMETER data
	The hashtable or object to test conditions against.
	
	.EXAMPLE
	$rules = @{
		conditions = @(
			@{ level = @("person", "Type"); operator = "Equals"; check = "Employee" }
		)
		result = "Matched Employee"
	}
	Test-ConditionSet -rules $rules -data $myData
	
	.NOTES
	Supported operators:
	- Equals, NotEquals
	- Contains, NotContains, In, NotIn
	- Like, NotLike, Match, NotMatch
	- GreaterThan, LessThan, GreaterOrEqual, LessOrEqual
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[hashtable] $rules,

		[Parameter(Mandatory)]
		$data
	)
	
	Write-Verbose "Testing $($rules.conditions.Count) condition(s)"
	$allMet = $true
	
	foreach ($condition in $rules.conditions) {
		if (-not $condition.level) {
			Write-Warning "Condition missing 'level' property, skipping"
			$allMet = $false
			break
		}
		
		$level = $condition.level
		$check = $condition.check
		$operator = if ($condition.operator) { $condition.operator } else { 
			Write-Verbose "No operator specified, defaulting to Equals"
			"Equals" 
		}
		
		$found = Get-InfoFromStruct -levels $level -data $data
		
		if ($null -eq $found -and $operator -ne "Equals") {
			Write-Verbose "Path not found, condition failed"
			$allMet = $false
			break
		}
		
		Write-Verbose "Checking: $found $operator $check"
		
		$conditionMet = switch ($operator) {
			"Equals" { $found -eq $check }
			"NotEquals" { $found -ne $check }
			"Contains" { $found -contains $check }
			"NotContains" { $found -notcontains $check }
			"In" { $found -in $check }
			"NotIn" { $found -notin $check }
			"Like" { $found -like $check }
			"NotLike" { $found -notlike $check }
			"Match" { $found -match $check }
			"NotMatch" { $found -notmatch $check }
			"GreaterThan" { $found -gt $check }
			"LessThan" { $found -lt $check }
			"GreaterOrEqual" { $found -ge $check }
			"LessOrEqual" { $found -le $check }
			default { 
				Write-Warning "Unknown operator '$operator', defaulting to Equals"
				$found -eq $check 
			}
		}
		
		if ($conditionMet) {
			Write-Verbose "✓ Condition met: $($level -join '.') $operator $check"
		} else {
			Write-Verbose "✗ Condition NOT met: $($level -join '.') $operator $check (found: $found)"
			$allMet = $false
			break
		}
	}
	
	if ($allMet) {
		Write-Verbose "✓ All conditions met, returning result"
		if ($rules.result -is [string]) {
			return $rules.result
		} else {
			return (Get-InfoFromStruct -levels $rules.result -data $data)
		}
	}
	
	Write-Verbose "✗ Not all conditions met, returning null"
	return $null
}

# Export only the public interface
Export-ModuleMember -Function Test-ConditionSet
