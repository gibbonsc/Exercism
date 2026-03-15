Function Invoke-Transpose() {
    [CmdletBinding()]
    Param(
        [string]$Text
    )
    $Rows = $Text -split "`n"
    $Shadows = @()
    $MaxDepth = 0
    foreach ($Row in $Rows) {
        $Depth = $Row.Length
        if ($MaxDepth -lt $Depth) {
            $MaxDepth = $Depth
        }
        for ($i=$Shadows.Length - 1; $i -ge 0; $i--) {
            if ($Shadows[$i] -lt $Depth) {
                $Shadows[$i] = $Depth
            }
            else {
                break
            }
        }
        $Shadows += , $Depth
    }
    $RowsT = (, $null) * $MaxDepth
    for ($i = 0; $i -lt $MaxDepth; $i++) {
        for ($j = 0; $j -lt $Shadows.Length; $j++) {
            if ($Rows[$j].Length -le $i -and $i -lt $Shadows[$j]) {
                $RowsT[$i] += " "
            }
            else {
                $RowsT[$i] += $Rows[$j][$i]
            }
        }
    }
    return $RowsT -join "`n"

    <#
    .SYNOPSIS
    Given an input text output it transposed.

    .DESCRIPTION
    Given a string, return the transposed string.
    The transpose of a matrix:
    ABC  =>  AD
    DEF      BE
             CF
    
    Rows become columns and columns become rows.

    .PARAMETER Text
    String to be transposed.

    .EXAMPLE
    Invoke-Transpose -Text "ABC`nDEF"
    Return:
    @"
    AD
    BE
    CF
    "@
    #>
}