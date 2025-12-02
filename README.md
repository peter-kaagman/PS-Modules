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

Copyright (c) 2025 Atlas College
