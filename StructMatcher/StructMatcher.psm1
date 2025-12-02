function Get-InfoFromStruct {
param (
[Parameter(Mandatory)]
[array] $levels,
[Parameter(Mandatory)]
$data
)
try {
foreach ($level in $levels) {
if ($null -eq $data) {
throw "Path not found at level: $level"
}
$data = $data.$level
}
return $data
}
catch {
Write-Warning "Error: $_"
return $null
}
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
"Contains" { $found -contains $check }
"NotContains" { $found -notcontains $check }
"In" { $found -in $check }
"NotIn" { $found -notin $check }
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
