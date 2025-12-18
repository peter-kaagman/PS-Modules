# AtlasHelloIDFunctions

Common HelloID functies voor Atlas College scripts

## Overzicht
Deze module bevat veelgebruikte hulpfuncties voor HelloID PowerShell-scripts binnen Atlas College. De module is bedoeld om codehergebruik en onderhoudbaarheid te bevorderen.

## Functies

### Get-JaarLagen
Haalt jaarlagen op uit een lokaal JSON-bestand en retourneert deze als een hashtable, geïndexeerd op de 'Title'-waarde.

**Parameters:**

**Voorbeeldgebruik:**
```powershell
Import-Module "C:\HelloId\PS-Modules\AtlasHelloIDFunctions" -Force
$jaarlagen = Get-JaarLagen -AktiefOnly $true
```

**Pad naar JSON-bestand:**

## Installatie
Plaats de map `AtlasHelloIDFunctions` in de directory `C:\HelloId\PS-Modules`.

## Release notes

## Auteur

# AtlasHelloIDFunctions Module

**Author:** Peter Kaagman ([prjv.kaagman@gmail.com](mailto:prjv.kaagman@gmail.com))  
**Copyright:** © Peter Kaagman

This module provides reusable functions for HelloID automation scripts, such as reading jaarlagen from a JSON file. It is designed to centralize and standardize common logic used across HelloID PowerShell scripts.

## Features

- Centralized reusable functions for HelloID automation
- Example: `Get-JaarLagen` for reading jaarlagen from a JSON file
- Consistent parameterization and error handling

## Usage

Import the module in your script:

```powershell
Import-Module "C:\HelloId\PS-Modules\AtlasHelloIDFunctions"
```

Call the functions as needed. For example:

```powershell
$jaarlagen = Get-JaarLagen -Path "C:\HelloId\JSON\jaarlagen.json"
```

## Example: Get Jaarlagen

```powershell
Import-Module "C:\HelloId\PS-Modules\AtlasHelloIDFunctions"

$jaarlagen = Get-JaarLagen -Path "C:\HelloId\JSON\jaarlagen.json"
foreach ($jaarlaag in $jaarlagen) {
	Write-Host $jaarlaag.Naam
}
```

## See Also

- [GraphHelper](../GraphHelper/README.md): Microsoft Graph API helper functions
- [JsonHelper](../JsonHelper/README.md): Utilities for working with JSON data in PowerShell

## License

This module is licensed under the [MIT License](../LICENSE).
