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

See [JsonHelper/README.md](JsonHelper/README.md) for detailed documentation.

### GraphHelper

Module for efficient Microsoft Graph API requests with pagination and memory optimization.

**Version:** 1.0.0  
**Author:** Peter Kaagman

**Functions:**
- `Invoke-GraphAPIRequest` - Retrieves data from Graph API with pagination support and optional hashtable conversion

**Features:**
- Automatic pagination handling through `@odata.nextlink`
- Memory-optimized for large datasets (tested with 2800+ items)
- Optional hashtable return for fast lookups
- Compatible with any Graph API endpoint (groups, users, devices, etc.)

**Example:**
```powershell
# Get teams as hashtable for memory efficiency
$teamHash = Invoke-GraphAPIRequest -Headers $headers `
    -Filter "resourceProvisioningOptions/Any(x:x eq 'Team')" `
    -Select "id,mailNickname,displayName" `
    -ReturnAsHashTable

# Fast lookup by mailNickname
$teamId = $teamHash["EduTeam_24-25_4A"].id
```

See [GraphHelper/README.md](GraphHelper/README.md) for detailed documentation.

## Installation

```powershell
# Clone the repository
git clone https://github.com/peter-kaagman/PS-Modules.git C:\HelloId\PS-Modules

# Import modules
Import-Module C:\HelloId\PS-Modules\StructMatcher
Import-Module C:\HelloId\PS-Modules\JsonHelper
Import-Module C:\HelloId\PS-Modules\GraphHelper
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
# Import modules from absolute path
Import-Module C:\HelloId\PS-Modules\StructMatcher
Import-Module C:\HelloId\PS-Modules\JsonHelper
Import-Module C:\HelloId\PS-Modules\GraphHelper

# Load JSON config as hashtable
$config = Get-JsonAsHashtable "config.json"

# Query Microsoft Graph API with pagination
$teams = Invoke-GraphAPIRequest -Headers $headers `
    -Filter "resourceProvisioningOptions/Any(x:x eq 'Team')" `
    -Select "id,mailNickname,displayName" `
    -ReturnAsHashTable

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
