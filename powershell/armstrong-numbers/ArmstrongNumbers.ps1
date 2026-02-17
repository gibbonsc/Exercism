Function Invoke-ArmstrongNumbers() {
    [CmdletBinding()]
    Param(
        [Int64]$Number
    )

    $DigitChars = [char[]][string]$Number
    $Digits = $DigitChars | Foreach-Object { [long]($_ - [char]'0') }
    $Exponent = $Digits.Count
    $SumOfPowersOfDigits = $Digits | ForEach-Object {
        $Total=0
    }{
        $Total += [Math]::Pow($_,$Exponent)
    }{
        $Total
    }
    Return $Number -eq $SumOfPowersOfDigits
    <#
    .SYNOPSIS
    Determine if a number is an Armstrong number.

    .DESCRIPTION
    An Armstrong number is a number that is the sum of its own digits each raised to the power of the number of digits.

    .PARAMETER Number
    The number to check.

    .EXAMPLE
    Invoke-ArmstrongNumbers -Number 12
    #>
}
