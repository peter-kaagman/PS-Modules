
# AtlasHelloIDFunctions Module


**Author:** Peter Kaagman ([prjv.kaagman@gmail.com](mailto:prjv.kaagman@gmail.com))  
**Copyright:** © Peter Kaagman

This module provides reusable functions for HelloID automation scripts, such as reading year layers (jaarlagen) from a JSON file. It is designed to centralize and standardize common logic used across HelloID PowerShell scripts.

## Features

- Centralized reusable functions for HelloID automation
- Example: `Get-JaarLagen` for reading year layers from a JSON file
- Consistent parameterization and error handling

## Usage

Import the module in your script:

```powershell
Import-Module "C:\HelloId\PS-Modules\AtlasHelloIDFunctions"
```

Call the functions as needed. For example:

```powershell
$yearLayers = Get-JaarLagen -Path "C:\HelloId\JSON\jaarlagen.json"
```

## Example: Get Year Layers

```powershell
Import-Module "C:\HelloId\PS-Modules\AtlasHelloIDFunctions"

$yearLayers = Get-JaarLagen -Path "C:\HelloId\JSON\jaarlagen.json"
foreach ($layer in $yearLayers) {
    Write-Host $layer.Name
}
```

## See Also

- [GraphHelper](../GraphHelper/README.md): Microsoft Graph API helper functions
- [JsonHelper](../JsonHelper/README.md): Utilities for working with JSON data in PowerShell

## License

This module is licensed under the [MIT License](../LICENSE).
