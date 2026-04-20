Function Get-RomanNumerals() {
    [CmdletBinding()]
    Param(
        [int]$Number
    )

    if ($Number -lt 1 -or 3999 -lt $Number) {
        throw "Number has to be positive integer in range of 1-3999."
    }

    $Units = $Number % 10
    $Tens = ($Number - $Units) / 10 % 10
    $Hundreds = ($Number - $Tens * 10 - $Units) / 100 % 10
    $Thousands = ($Number - $Hundreds * 100 - $Tens * 10 - $Units) / 1000

    $RomanUnits = @(
        "", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"
    )[$Units]
    $RomanTens = @(
        "", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC"
    )[$Tens]
    $RomanHundreds = @(
        "", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM"
    )[$Hundreds]
    $RomanThousands = @(
        "", "M", "MM", "MMM"
    )[$Thousands]

    Return $RomanThousands + $RomanHundreds + $RomanTens + $RomanUnits

    <#
    .SYNOPSIS
    Given a number, convert it into a roman numeral.

    .DESCRIPTION
    Convert a positive integer into a string representation of that integer in roman numeral form.
    
    .PARAMETER Number
    The number to turn into roman numeral.

    .EXAMPLE
    Get-RomanNumerals -Number 1
    return: 'I'
    Get-RomanNumerals -Number 3999
    return: 'MMMCMXCIX'
    #>
}