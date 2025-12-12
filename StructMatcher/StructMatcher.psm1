function Get-InfoFromStruct {
    param (
        [Parameter(Mandatory)]
        [array] $levels,
        [Parameter(Mandatory)]
        $data
    )
    foreach ($level in $levels) {
        if ($null -eq $data) {
            # Property path leads to null - return null without error
            return $null
        }
        
        # Check if property exists (supports both hashtables and PSCustomObjects)
        $hasProperty = if ($data -is [hashtable]) {
            $data.ContainsKey($level)
        } else {
            $null -ne $data.PSObject.Properties[$level]
        }
        
        if (-not $hasProperty) {
            # Property doesn't exist - this is normal for optional fields
            return $null
        }
        
        $data = $data.$level
    }
    return $data
}

function Test-ConditionSet {
    param (
        [Parameter(Mandatory)]
        [hashtable] $rules,
        [Parameter(Mandatory)]
        $data
    )
    $allMet = $true
    foreach ($condition in $rules.conditions) {
        $level = $condition.level
        $check = $condition.check
        $operator = if ($condition.operator) { $condition.operator } else { "Equals" }
        $found = Get-InfoFromStruct -levels $level -data $data
        $conditionMet = switch ($operator) {
            "Equals" { $found -eq $check }
            "NotEquals" { $found -ne $check }
            "Contains" {
                # Robuuste contains: forceer $found naar array van strings indien mogelijk
                $arr = $found
                if ($null -eq $arr) {
                    $arr = @()
                } elseif ($arr -is [string]) {
                    # Probeer te parsen als JSON-array, anders split op komma
                    try {
                        $parsed = $null
                        if ($arr.Trim().StartsWith("[") -and $arr.Trim().EndsWith("]")) {
                            $parsed = $arr | ConvertFrom-Json -ErrorAction Stop
                        }
                        if ($parsed -is [array]) {
                            $arr = $parsed
                        } else {
                            $arr = $arr -split ','
                        }
                    } catch {
                        $arr = $arr -split ','
                    }
                } elseif ($arr -isnot [array]) {
                    $arr = @($arr)
                }
                # Flatten indien genest
                while ($arr.Count -eq 1 -and $arr[0] -is [array]) { $arr = $arr[0] }
                $arr -contains $check
            }
            "NotContains" {
                $arr = $found
                if ($null -eq $arr) {
                    $arr = @()
                } elseif ($arr -is [string]) {
                    try {
                        $parsed = $null
                        if ($arr.Trim().StartsWith("[") -and $arr.Trim().EndsWith("]")) {
                            $parsed = $arr | ConvertFrom-Json -ErrorAction Stop
                        }
                        if ($parsed -is [array]) {
                            $arr = $parsed
                        } else {
                            $arr = $arr -split ','
                        }
                    } catch {
                        $arr = $arr -split ','
                    }
                } elseif ($arr -isnot [array]) {
                    $arr = @($arr)
                }
                while ($arr.Count -eq 1 -and $arr[0] -is [array]) { $arr = $arr[0] }
                $arr -notcontains $check
            }
            "In" {
                $arr = $check
                if ($null -eq $arr) {
                    $arr = @()
                } elseif ($arr -is [string]) {
                    try {
                        $parsed = $null
                        if ($arr.Trim().StartsWith("[") -and $arr.Trim().EndsWith("]")) {
                            $parsed = $arr | ConvertFrom-Json -ErrorAction Stop
                        }
                        if ($parsed -is [array]) {
                            $arr = $parsed
                        } else {
                            $arr = $arr -split ','
                        }
                    } catch {
                        $arr = $arr -split ','
                    }
                } elseif ($arr -isnot [array]) {
                    $arr = @($arr)
                }
                while ($arr.Count -eq 1 -and $arr[0] -is [array]) { $arr = $arr[0] }
                $found -in $arr
            }
            "NotIn" {
                $arr = $check
                if ($null -eq $arr) {
                    $arr = @()
                } elseif ($arr -is [string]) {
                    try {
                        $parsed = $null
                        if ($arr.Trim().StartsWith("[") -and $arr.Trim().EndsWith("]")) {
                            $parsed = $arr | ConvertFrom-Json -ErrorAction Stop
                        }
                        if ($parsed -is [array]) {
                            $arr = $parsed
                        } else {
                            $arr = $arr -split ','
                        }
                    } catch {
                        $arr = $arr -split ','
                    }
                } elseif ($arr -isnot [array]) {
                    $arr = @($arr)
                }
                while ($arr.Count -eq 1 -and $arr[0] -is [array]) { $arr = $arr[0] }
                $found -notin $arr
            }
            "Like" { $found -like $check }
            "NotLike" { $found -notlike $check }
            "Match" { $found -match $check }
            "NotMatch" { $found -notmatch $check }
            "GreaterThan" { $found -gt $check }
            "LessThan" { $found -lt $check }
            "GreaterOrEqual" { $found -ge $check }
            "LessOrEqual" { $found -le $check }
            default { $found -eq $check }
        }
        if (-not $conditionMet) {
            $allMet = $false
            break
        }
    }
    if ($allMet) {
        if ($rules.result -is [string]) {
            return $rules.result
        } else {
            return (Get-InfoFromStruct -levels $rules.result -data $data)
        }
    }
    return $null
}

Export-ModuleMember -Function Test-ConditionSet
