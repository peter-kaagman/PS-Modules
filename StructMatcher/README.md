# StructMatcher Module

PowerShell module for navigating nested hashtable structures and testing conditions.

## Installation

```powershell
Import-Module C:\HelloId\StructMatcher
```

## Public Functions

### Test-ConditionSet

Tests multiple conditions against a hashtable structure with AND logic. This is the main entry point of the module.

**Important:** This function expects **hashtables** as input. If you have PSCustomObjects (e.g., from `ConvertFrom-Json`), use the [JsonHelper module](../JsonHelper/README.md) to convert them first.

**Parameters:**
- `rules` - Hashtable with `conditions` and `result` properties (type: `[hashtable]`)
- `data` - The hashtable to test against (can contain nested hashtables and arrays)

**Condition Properties:**
- `level` - Array of property names representing the path through the nested structure (can be any depth)
- `operator` - Comparison operator to use (see supported operators below)
- `check` - Value to compare against

**Supported Operators:**
- `Equals`, `NotEquals`
- `Contains`, `NotContains`, `In`, `NotIn`
- `Like`, `NotLike`, `Match`, `NotMatch`
- `GreaterThan`, `LessThan`, `GreaterOrEqual`, `LessOrEqual`

**Example:**
```powershell
# Example data structure
$myData = @{
    person = @{
        type = "Employee"
        department = "Finance"
        name = "John Doe"
    }
}

# Define matching rules with multiple conditions (AND logic)
$rules = @{
    conditions = @(
        @{ 
            level = @("person", "type")
            operator = "Equals"
            check = "Employee"
        },
        @{
            level = @("person", "department")
            operator = "Equals"
            check = "Finance"
        }
    )
    result = "Finance Employee Matched!"
}

Test-ConditionSet -rules $rules -data $myData
# Returns: "Finance Employee Matched!" (both conditions are true)

# Example with deeper nesting
$deepData = @{
    company = @{
        department = @{
            team = @{
                member = @{
                    name = "Jane"
                    role = "Developer"
                }
            }
        }
    }
}

$deepRules = @{
    conditions = @(
        @{
            level = @("company", "department", "team", "member", "role")
            operator = "Equals"
            check = "Developer"
        }
    )
    result = "Developer found!"
}

Test-ConditionSet -rules $deepRules -data $deepData
# Returns: "Developer found!" (navigates 5 levels deep)
```

## Working with JSON

If your data comes from JSON files, use the JsonHelper module to convert to hashtables:

```powershell
# Load modules
Import-Module C:\HelloId\PS-Modules\StructMatcher
Import-Module C:\HelloId\PS-Modules\JsonHelper

# Load JSON data as hashtable
$rules = Get-JsonAsHashtable "C:\config\rules.json"
$data = Get-JsonAsHashtable "C:\data\employees.json"

# Test conditions
$result = Test-ConditionSet -rules $rules -data $data

# Alternative: Convert existing PSCustomObject
$jsonData = Get-Content "data.json" | ConvertFrom-Json
$hashtableData = ConvertTo-Hashtable $jsonData
$result = Test-ConditionSet -rules $rules -data $hashtableData
```

## Internal Functions

The module uses `Get-InfoFromStruct` internally for navigating hashtable structures. This function is not exported and cannot be called directly by users of the module.

## Version History

- **1.0.0** - Initial release
