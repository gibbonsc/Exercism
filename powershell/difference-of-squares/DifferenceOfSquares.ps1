Function Get-SquareOfSum() {
    [CmdletBinding()]
    Param(
        [Int64]$Number
    )

    $Sum = ($Number + 1) * $Number / 2
    Return $Sum * $Sum
    <#
    .SYNOPSIS
    Get the square of sum of a number.

    .DESCRIPTION
    Given a number, return the square of sum of all numbers up to and including that number.

    .PARAMETER Number
    The number to calculate the square of sum.
    
    .EXAMPLE
    Get-SquareOfSum -Number 12
    #>
}

Function Get-SumOfSquares() {
    [CmdletBinding()]
    Param(
        [Int64]$Number
    )

    Return ($Number * $Number * $Number * 2 + $Number * $Number * 3 + $Number) / 6
    <#
    .SYNOPSIS
    Get the sum of squares of a number.

    .DESCRIPTION
    Given a number, return the sum of squares of all numbers up to and including that number.

    .PARAMETER Number
    The number to calculate the sum of squares.

    .EXAMPLE
    Get-SumOfSquares -Number 12
    #>
}

Function Get-DifferenceOfSquares() {
    [CmdletBinding()]
    Param(
        [Int64]$Number
    )

    Return (Get-SquareOfSum $Number) - (Get-SumOfSquares $Number)
    <#
    .SYNOPSIS
    Get the difference of squares of a number.

    .DESCRIPTION
    Given a number, return the difference of squares of all numbers up to and including that number.

    .PARAMETER Number
    The number to calculate the difference of squares.

    .EXAMPLE
    Get-DifferenceOfSquares -Number 12
    #>
}
