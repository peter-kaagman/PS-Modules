# StructMatcher Module

PowerShell module for navigating nested hashtable structures and testing conditions.

## Installation

```powershell
Import-Module C:\HelloId\StructMatcher
```

## Public Functions

### Test-ConditionSet

Tests multiple conditions against a hashtable structure with AND logic. This is the main entry point of the module.

**Parameters:**
- `rules` - Hashtable with `conditions` and `result` properties
- `data` - The hashtable to test against

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

## Internal Functions

The module uses `Get-InfoFromStruct` internally for navigating hashtable structures. This function is not exported and cannot be called directly by users of the module.

## Version History

- **1.0.0** - Initial release
