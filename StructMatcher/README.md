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

**Supported Operators:**
- `Equals`, `NotEquals`
- `Contains`, `NotContains`, `In`, `NotIn`
- `Like`, `NotLike`, `Match`, `NotMatch`
- `GreaterThan`, `LessThan`, `GreaterOrEqual`, `LessOrEqual`

**Example:**
```powershell
$rules = @{
    conditions = @(
        @{ 
            level = @("person", "type")
            operator = "Equals"
            check = "Employee"
        }
    )
    result = "Matched!"
}

Test-ConditionSet -rules $rules -data $myData
```

## Internal Functions

The module uses `Get-InfoFromStruct` internally for navigating hashtable structures. This function is not exported and cannot be called directly by users of the module.

## Version History

- **1.0.0** - Initial release
