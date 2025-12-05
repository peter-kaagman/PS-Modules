function Invoke-GraphAPIRequest {
    <#
    .SYNOPSIS
    Retrieves data from Microsoft Graph API with pagination support and optional hashtable conversion.

    .DESCRIPTION
    Fetches data from Microsoft Graph API endpoints with automatic pagination handling. 
    Can return results as an array or as a hashtable for efficient lookups on specific properties.
    This function is memory-optimized for large datasets (tested with 2800+ items).

    .PARAMETER Headers
    Authentication headers dictionary containing Bearer token. Create with New-AuthorizationHeaders or similar.

    .PARAMETER Filter
    OData filter expression for the API query (e.g., "resourceProvisioningOptions/Any(x:x eq 'Team')")

    .PARAMETER Select
    Comma-separated list of properties to retrieve (e.g., "id,mailNickname,mail")

    .PARAMETER ReturnAsHashTable
    If specified, returns results as a hashtable keyed by a property value.
    Significantly reduces memory usage for large datasets compared to returning arrays.

    .PARAMETER HashTableKeyProperty
    Property name to use as hashtable key when -ReturnAsHashTable is specified.
    Default is the first property in -Select parameter.
    Example: -HashTableKeyProperty "mailNickname" or -HashTableKeyProperty "id"

    .PARAMETER Endpoint
    The Graph API endpoint to query. Default is "groups" (full URI: https://graph.microsoft.com/v1.0/groups)

    .EXAMPLE
    # Get teams as array (all properties)
    $headers = New-AuthorizationHeaders -TenantId $tenantId -ClientId $clientId -ClientSecret $secret
    $teams = Invoke-GraphAPIRequest -Headers $headers -Filter "resourceProvisioningOptions/Any(x:x eq 'Team')" -Select "id,mailNickname,displayName"

    .EXAMPLE
    # Get teams as hashtable keyed by mailNickname (memory efficient for 2800+ items)
    $teamHash = Invoke-GraphAPIRequest -Headers $headers `
        -Filter "resourceProvisioningOptions/Any(x:x eq 'Team') & startswith(mailNickname,'EduTeam_24-25')" `
        -Select "id,mailNickname,mail" `
        -ReturnAsHashTable

    # Quick lookup by mailNickname
    $teamId = $teamHash["EduTeam_24-25_4A"].id

    .EXAMPLE
    # Query different endpoint
    $users = Invoke-GraphAPIRequest -Headers $headers -Endpoint "users" -Filter "userType eq 'Member'" -Select "id,userPrincipalName,displayName"

    .NOTES
    Memory optimization:
    - Uses ArrayList instead of array concatenation (+= operator) for efficient batch additions
    - Builds hashtable directly without intermediate array conversion when -ReturnAsHashTable is specified
    - Automatically handles pagination through @odata.nextlink
    - Compatible with PowerShell 5.1
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[[String], [String]]]
        $Headers,

        [Parameter(Mandatory)]
        [string]
        $Filter,

        [Parameter(Mandatory)]
        [string]
        $Select,

        [switch]
        $ReturnAsHashTable,

        [string]
        $HashTableKeyProperty,

        [string]
        $Endpoint = "groups"
    )
    try {
        Write-Host "Getting list of $Endpoint"
        $baseUri = "https://graph.microsoft.com/"
        $Uri = "$($baseUri)/v1.0/$($Endpoint)?`$top=999&`$count=true&`$filter=$($Filter)&`$select=$($Select)"
        
        $request = @{
            Uri         = $Uri
            Headers     = $Headers
            Method      = "GET"
            Verbose     = $false
            ErrorAction = "Stop"
        }
        
        if ($ReturnAsHashTable) {
            $result = @{}
            # Determine key property: use provided parameter or first property in Select
            if ([string]::IsNullOrEmpty($HashTableKeyProperty)) {
                $HashTableKeyProperty = ($Select -split ',')[0].Trim()
            }
            Write-Verbose "Using '$HashTableKeyProperty' as hashtable key property"
        } else {
            $result = [System.Collections.ArrayList]::new()
        }
        
        $response = Invoke-RestMethod @request
        while ($null -ne $response) {
            if ($response.Value) {
                foreach ($item in $response.Value) {
                    if ($ReturnAsHashTable) {
                        $key = $item.$HashTableKeyProperty
                        if ([string]::IsNullOrEmpty($key)) {
                            Write-Warning "Item is missing property '$HashTableKeyProperty', skipping"
                            continue
                        }
                        $result[$key] = $item
                    } else {
                        [void]$result.Add($item)
                    }
                }
            }
            if ($response.'@odata.nextlink') {
                # If there is a next link, we need to call the API again
                $request.Uri = $response.'@odata.nextlink'
                $response = Invoke-RestMethod @request
            } else {
                # No next link, we are done
                $response = $null
            }
        }
        return $result
    }
    catch {
        throw $_
    }
}

Export-ModuleMember -Function Invoke-GraphAPIRequest
