
# GraphHelper Module

**Author:** Peter Kaagman ([prjv.kaagman@gmail.com](mailto:prjv.kaagman@gmail.com))  
**Copyright:** © Peter Kaagman

This module provides helper functions for interacting with Microsoft Graph API in PowerShell scripts. It is designed to simplify authentication, requests, and error handling when working with Microsoft Graph in HelloID automation scenarios.

## Features

- Simplified authentication to Microsoft Graph
- Helper functions for common Graph API operations
- Automatic handling of pagination and throttling (429 errors)
- Consistent error handling and logging

## Usage

Import the module in your script:

```powershell
Import-Module "C:\HelloId\PS-Modules\GraphHelper"
```

Call the helper functions as needed. For example:

```powershell
$token = Get-GraphToken -TenantId $tenantId -ClientId $clientId -ClientSecret $clientSecret
$users = Get-GraphUsers -Token $token
```

## Example: Get Users from Microsoft Graph

```powershell
Import-Module "C:\HelloId\PS-Modules\GraphHelper"

$token = Get-GraphToken -TenantId $tenantId -ClientId $clientId -ClientSecret $clientSecret
$users = Get-GraphUsers -Token $token
foreach ($user in $users) {
    Write-Host $user.displayName
}
```

## Error Handling

The module automatically retries requests on 429 (Too Many Requests) errors, using the recommended retry-after interval. All errors are logged for troubleshooting.

## Related Modules

- [AtlasHelloIDFunctions](../AtlasHelloIDFunctions/README.md): Provides reusable HelloID functions, such as `Get-JaarLagen` for reading year layers from JSON files. Example usage:

    ```powershell
    Import-Module "C:\HelloId\PS-Modules\AtlasHelloIDFunctions"
    $yearLayers = Get-JaarLagen -Path "C:\HelloId\JSON\jaarlagen.json"
    ```

- [JsonHelper](../JsonHelper/README.md): Utilities for working with JSON data in PowerShell.

## License

This module is licensed under the [MIT License](../LICENSE).
### Example 2: Get Teams as Hashtable (Memory Efficient)

```powershell
# For 2800+ teams, use hashtable to save memory
# Key by mailNickname (default is first property in Select)
$teamHash = Invoke-GraphAPIRequest -Headers $authHeaders `
    -Filter "resourceProvisioningOptions/Any(x:x eq 'Team') & startswith(mailNickname,'EduTeam_24-25')" `
    -Select "id,mailNickname,mail" `
    -ReturnAsHashTable

# Fast lookup by mailNickname
$teamId = $teamHash["EduTeam_24-25_4A"].id
```

### Example 2b: Hashtable with Custom Key Property

```powershell
# Key by ID instead of mailNickname
$teamHashById = Invoke-GraphAPIRequest -Headers $authHeaders `
    -Filter "resourceProvisioningOptions/Any(x:x eq 'Team')" `
    -Select "id,mailNickname,displayName" `
    -ReturnAsHashTable `
    -HashTableKeyProperty "id"

# Fast lookup by ID
$displayName = $teamHashById["550e8400-e29b-41d4-a716-446655440000"].displayName
```

### Example 3: Query Users

```powershell
$users = Invoke-GraphAPIRequest -Headers $authHeaders `
    -Endpoint "users" `
    -Filter "userType eq 'Member'" `
    -Select "id,userPrincipalName,displayName"
```

### Example 4: Real-world Usage in Permissions Script

```powershell
# Get authorization headers (example with external function)
$authHeaders = New-AuthorizationHeaders -TenantId $tenantId -ClientId $clientId -ClientSecret $secret

# Build team lookup hashtable keyed by mailNickname
$filter = "resourceProvisioningOptions/Any(x:x eq 'Team')"
$filter += " & startswith(mailNickname,'EduTeam_$schoolYear')"

$teamLookup = Invoke-GraphAPIRequest -Headers $authHeaders `
    -Filter $filter `
    -Select "id,mailNickname,mail" `
    -ReturnAsHashTable `
    -HashTableKeyProperty "mailNickname"

# Use in loop for fast lookups
foreach ($contract in $personContext.Person.Contracts) {
    foreach ($kG in $contract.Custom.klasGroepen) {
        $teamName = "EduTeam_$($schoolYear)_$kG"
        $teamId = $teamLookup[$teamName].id
        if ($teamId) {
            # Grant permission with $teamId
        }
    }
}
```

## Performance Notes

### Memory Optimization

This module is optimized for large datasets:

- **ArrayList Usage**: Uses `[System.Collections.ArrayList]` instead of array concatenation (`+=`) to avoid quadratic memory overhead
- **Direct Hashtable Building**: When `-ReturnAsHashTable` is specified, the hashtable is built directly without an intermediate array
- **Automatic Pagination**: Handles Microsoft Graph's pagination transparently
- **Tested**: Successfully processes 2800+ items within 512MB memory limit

### Typical Memory Usage

- Array return with 2800 items: ~150-200MB
- Hashtable return with 2800 items: ~150-200MB (same, just different access pattern)
- Without optimization: ~600MB+ (due to array concatenation overhead)

## Comparison: With vs Without Module

### Before (without module - memory inefficient)

```powershell
$result = @()  # Start with empty array
$response = Invoke-RestMethod @request

while ($null -ne $response) {
    $result += $response.Value  # INEFFICIENT: Creates new array on each iteration
    if ($response.'@odata.nextlink') {
        $request.Uri = $response.'@odata.nextlink'
        $response = Invoke-RestMethod @request
    } else {
        $response = $null
    }
}

$hashtable = $result | Group-Object mailNickname -AsHashTable  # Extra memory usage!
```

### After (using module - memory efficient)

```powershell
$hashtable = Invoke-GraphAPIRequest -Headers $headers `
    -Filter $filter `
    -Select "id,mailNickname,mail" `
    -ReturnAsHashTable  # Direct hashtable, no intermediate array
```

## Version History

- **1.0.0** (2025-12-04) - Initial release
  - Function: `Invoke-GraphAPIRequest`
  - Features: Pagination handling, hashtable conversion, memory optimization
  - Compatible: PowerShell 5.1+

## See Also

- [Microsoft Graph API Documentation](https://docs.microsoft.com/en-us/graph/overview)
- [OData Filter Syntax](https://docs.microsoft.com/en-us/graph/query-parameters)
- [Related Modules](../): StructMatcher, JsonHelper
