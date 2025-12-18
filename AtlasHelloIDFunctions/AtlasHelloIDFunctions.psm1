Import-Module -Name "C:\HelloId\PS-Modules\JsonHelper" -Force

function Get-JaarLagen {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [bool]$AktiefOnly = $false,
        [Parameter(Mandatory=$false)]
        [string]$Path = "C:\HelloId\JSON\jaarlagen.json"
    )
    $bron = Get-JsonAsHashtable $Path
    $hash = @{}
    if ($AktiefOnly) {
        foreach ($prop in $bron.GetEnumerator()) {
            if ($prop.Value.Aktief) {
                $hash[$prop.Name] = $prop.Value
            }
        }
    } else {
        $hash = $bron
    }
    Write-Verbose "Done Jaarlagen ophalen"
    return $hash
}
