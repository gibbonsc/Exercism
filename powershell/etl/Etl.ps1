Function Invoke-Etl() {
    [CmdletBinding()]
    Param(
        [object]$Legacy
    )

    $Result = @{}
    $Legacy.keys | ForEach-Object {
        $PointValue = $_
        $Legacy[$PointValue] | Foreach-Object {
            $Letter = $_
            $Result["$Letter"] = $PointValue
        }
    }
    Return $Result
    <#
    .SYNOPSIS
    Transforms a set of legacy Lexiconia data stored as letters per score to a set of data stored score per letter.

    .DESCRIPTION
    Take a hash table and take the values as keys and the keys as values.

    .PARAMETER Legacy
    The legacy data to transform.

    .EXAMPLE
    Invoke-Etl -Legacy @{1 = @("A")}
    #>
}
