Function Invoke-Counter() {
    [CmdletBinding()]
    Param(
        [int]$Value
    )
    $Bits = [uint]$Value
    $Result = 0
    while ($Bits -gt 0) {
        $Result += ($Bits % 2)
        $Bits = $Bits -shr 1
    }
    Return $Result
    <#
    .SYNOPSIS
    Count the number of '1' bits in the binary representation of a decimal number.

    .DESCRIPTION
    Given an integer, count all the '1' bits from the binary representation of that integer.
    Example: 25 is '11001' in binary form, and has 3 bits which are '1'.

    .PARAMETER Value
    Integer represent the decimal value being displayed.

    .EXAMPLE
    Invoke-Counter -Value 12345
    Returns: 6
    #>
}