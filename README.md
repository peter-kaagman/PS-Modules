# PS-Modules

PowerShell modules collection for Atlas College HelloID scripts.

## Modules

### StructMatcher

Module for navigating nested hashtable structures and testing conditions against them.

**Version:** 1.0.0  
**Author:** Peter Kaagman

See [StructMatcher/README.md](StructMatcher/README.md) for detailed documentation.

## Installation

```powershell
# Clone the repository
git clone https://github.com/peter-kaagman/PS-Modules.git C:\HelloId\PS-Modules

# Import a module
Import-Module C:\HelloId\PS-Modules\StructMatcher
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
# Import from relative path
Import-Module ..\PS-Modules\StructMatcher

# Use the module
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

## Development

Each module has its own subdirectory with:
- `.psm1` - Module script file
- `.psd1` - Module manifest
- `README.md` - Module documentation

## License

MIT License - see [LICENSE](LICENSE) file for details.

Copyright (c) 2025 Peter Kaagman
