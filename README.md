# PS-Modules

PowerShell modules collection for Atlas College HelloID scripts.

## Modules

### StructMatcher

Module for navigating nested hashtable structures and testing conditions against them.

**Version:** 1.0.0  
**Author:** Peter Kaagman

See [StructMatcher/README.md](StructMatcher/README.md) for detailed documentation.

### JsonHelper

Module for reading JSON files and converting them to PowerShell hashtables.

**Version:** 1.0.0  
**Author:** Peter Kaagman

**Functions:**
- `Get-JsonAsHashtable` - Reads a JSON file and returns its content as a hashtable
- `ConvertTo-Hashtable` - Converts PSCustomObject to hashtable recursively

**Example:**
```powershell
# Read JSON file directly as hashtable
$config = Get-JsonAsHashtable -Path "C:\config.json"

# Convert existing PSCustomObject
$json = '{"key":"value"}' | ConvertFrom-Json
$hash = ConvertTo-Hashtable $json
```

## Installation

```powershell
# Clone the repository
git clone https://github.com/peter-kaagman/PS-Modules.git C:\HelloId\PS-Modules

# Import modules
Import-Module C:\HelloId\PS-Modules\StructMatcher
Import-Module C:\HelloId\PS-Modules\JsonHelper
```

### Using Symbolic Links

For easier access from other repositories, you can create a symbolic link:

```powershell
# From your script repository directory
cd C:\HelloId\YourScriptRepo
New-Item -ItemType SymbolicLink -Path "PS-Modules" -Target "..\PS-Modules"

# Or link individual modules
New-Item -ItemType SymbolicLink -Path "StructMatcher" -Target "..\PS-Modules\StructMatcher"

# Then import using relative paths
Import-Module .\StructMatcher
```

This allows you to maintain the modules in one location while using them across multiple projects without duplication.

## Usage in Scripts

```powershell
# Import modules from relative path
Import-Module ..\PS-Modules\StructMatcher
Import-Module ..\PS-Modules\JsonHelper

# Load JSON config as hashtable
$config = Get-JsonAsHashtable "config.json"

# Use StructMatcher to test conditions
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

Test-ConditionSet -rules $rules -data $config
```

## Development

Each module has its own subdirectory with:
- `.psm1` - Module script file
- `.psd1` - Module manifest
- `README.md` - Module documentation

## License

MIT License - see [LICENSE](LICENSE) file for details.

Copyright (c) 2025 Peter Kaagman
