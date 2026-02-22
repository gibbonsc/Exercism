Function Get-GrainSquare() {
    [CmdletBinding()]
    Param(
        [BigInt]$Number
    )
    if ($Number -lt 1 -or $Number -gt 64) { throw "square must be between 1 and 64" }
    Return [BigInt]1 -shl ($Number - 1)
    <#
    .SYNOPSIS
    Get the number of grains on a square.

    .DESCRIPTION
    Given a number, return the number of grains on that square.
    
    .PARAMETER Number
    Which square to get the number of grains.
    
    .EXAMPLE
    Get-GrainSquare -Number 2
    #>
}

Function Get-GrainTotal() {    
    Return ([BigInt]1 -shl 64) -1
    <#
    .SYNOPSIS
    Get the total number of grains.

    .DESCRIPTION
    Return the total number of grains on the board.

    .EXAMPLE
    Get-GrainTotal
    #>
}
