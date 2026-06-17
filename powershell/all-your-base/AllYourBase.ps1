Function Invoke-Rebase() {
    [CmdletBinding()]
    Param(
        [int[]]$Digits,
        [int]$InputBase,
        [int]$OutputBase
    )
    # validate input
    if ($InputBase -lt 2) {
        throw "input base must be >= 2"
    }
    if ($OutputBase -lt 2) {
        throw "output base must be >= 2"
    }

    # parse digits
    $Num = 0
    foreach ($Digit in $Digits) {
        if ($Digit -lt 0 -or $InputBase -le $Digit) {
            throw "all digits must satisfy 0 <= digit < input base"
        }
        $Num *= $InputBase
        $Num += $Digit
    }

    # calculate and return new digits
    $Result = @()
    while ($Num -gt 0) {
        $Digit = $Num % $OutputBase
        $Num -= $Digit
        $Num /= $OutputBase
        $Result = , $Digit + $Result
    }
    if (0 -eq $Result.Count) { $Result = @(0) }
    Return @($Result)
    <#
    .SYNOPSIS
    Convert a number, represented as a sequence of digits in one base, to any other base.

    .DESCRIPTION
    Implement general base conversion of a number.
    Given an array of digits represent a number in base "a", convert it and return an array of digits represent the same number in base "b".

    .PARAMETER Digits
    Array of digits represent the number to be converted.

    .PARAMETER InputBase
    The original base of the number.

    .PARAMETER OutputBase
    The base to be converted to.

    .EXAMPLE
    Invoke-Rebase -Digits @(1, 0, 1 , 0 ,1 ) -InputBase 2 -OutputBase 10
    return : @(2, 1)
    #>
}
