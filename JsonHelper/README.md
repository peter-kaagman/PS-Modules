

# JsonHelper Module

**Author:** Peter Kaagman ([prjv.kaagman@gmail.com](mailto:prjv.kaagman@gmail.com))  
**Copyright:** © Peter Kaagman

PowerShell module for reading JSON files and converting them to native PowerShell hashtables.

## Overview

When using `ConvertFrom-Json` in PowerShell, the result is a PSCustomObject which can cause issues when working with code that expects hashtables. This module provides utilities to convert JSON content directly to hashtables, including nested objects and arrays.

## Functions

### Get-JsonAsHashtable

Reads a JSON file and returns its content as a hashtable structure.

**Syntax:**
```powershell
Get-JsonAsHashtable [-Path] <string> [-Raw]
```

**Parameters:**
- `Path` - The path to the JSON file to read (mandatory, accepts pipeline input)
- `Raw` - If specified, returns PSCustomObject without converting to hashtable

**Examples:**

```powershell
# Read a JSON configuration file
$config = Get-JsonAsHashtable -Path "C:\config\settings.json"
Write-Host $config.database.connectionString

# Using pipeline and positional parameter
$data = Get-JsonAsHashtable "C:\data\users.json"

# Get raw PSCustomObject instead of hashtable
$raw = Get-JsonAsHashtable "C:\data.json" -Raw
```

### ConvertTo-Hashtable

Recursively converts PSCustomObject instances to hashtables.

**Syntax:**
```powershell
ConvertTo-Hashtable [-InputObject] <object>
```

**Parameters:**
- `InputObject` - The object to convert (mandatory, accepts pipeline input)

**Examples:**

```powershell
# Convert JSON string to hashtable
$json = '{"name":"John","age":30,"address":{"city":"Amsterdam"}}'
$hash = $json | ConvertFrom-Json | ConvertTo-Hashtable

# Convert array of objects
$jsonArray = '[{"id":1},{"id":2}]'
$hashArray = ($jsonArray | ConvertFrom-Json) | ConvertTo-Hashtable

# Check the result type
$hash.GetType().Name  # Returns: Hashtable
```

## Use Cases

### Configuration Files

```powershell
# Load application configuration
$config = Get-JsonAsHashtable "C:\app\config.json"

# Access nested properties
$apiKey = $config.settings.api.key
$timeout = $config.settings.api.timeout
```

### Condition Sets

```powershell
# Load condition rules from JSON
$rules = Get-JsonAsHashtable "C:\rules\conditions.json"

# Use with StructMatcher module
Import-Module StructMatcher
foreach ($rule in $rules) {
    $result = Test-ConditionSet -rules $rule -data $myData
    if ($result) {
        Write-Host "Match found: $result"
    }
}
```

### Data Processing

```powershell
# Load data from external JSON
$employees = Get-JsonAsHashtable "C:\data\employees.json"

# Process with hashtable operations
foreach ($emp in $employees) {
    if ($emp.department -eq "IT") {
        Write-Host "$($emp.name) works in IT"
    }
}
```

## Why Hashtables?

**PSCustomObject limitations:**
- Cannot be used with parameters typed as `[hashtable]`
- Different syntax for accessing properties
- Less flexible for dynamic property manipulation

**Hashtable advantages:**
- Native PowerShell type with full language support
- Easy property addition/removal: `$hash.newKey = "value"`
- Compatible with splat operators: `@splatParams`
- Works with cmdlets expecting hashtables

## Error Handling

Both functions include error handling:

```powershell
try {
    $data = Get-JsonAsHashtable "C:\nonexistent.json"
}
catch {
    Write-Error "Failed to load JSON: $_"
}
```

**Common errors:**
- `File not found` - The specified path doesn't exist
- `Error reading or parsing JSON` - Invalid JSON syntax in the file

## Installation

```powershell
# Import the module
Import-Module C:\HelloId\PS-Modules\JsonHelper

# Or use relative path
Import-Module ..\PS-Modules\JsonHelper
```

## Requirements

- PowerShell 5.1 or higher
- Read access to JSON files

## Version History

**1.0.0** - Initial release
- Get-JsonAsHashtable function
- ConvertTo-Hashtable function
- Full comment-based help
- Error handling for file operations


## License

This module is licensed under the [MIT License](../LICENSE).

## See Also

- [StructMatcher Module](../StructMatcher/README.md) - Test conditions against nested structures
- [PS-Modules Repository](https://github.com/peter-kaagman/PS-Modules)
