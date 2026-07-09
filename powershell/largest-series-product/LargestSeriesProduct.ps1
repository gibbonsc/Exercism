Function Get-Product {
    [CmdletBinding()]
    Param(
        [int[]]$Factors
    )
    $Factors | ForEach-Object {
        $return = 1
    } {
        $return *= $_
    } {
        $return
    }
    return $return
}

Function Get-LargestSeriesProduct() {
    [CmdletBinding()]
    Param(
        [string]$Digits,
        [int]$Span
    )
    $DLen = $Digits.Length
    if ($Span -gt $DLen) { throw "span must not exceed string length" }
    if ($Span -lt 0) { throw "span must not be negative" }
    $DigitArray = [int[]][char[]]$Digits | ForEach-Object {
        $_ - [int][char]'0'
    }
    $Validate = $DigitArray | Where-Object { 0 -gt $_ -or $_ -gt 9 }
    if ($Validate.Count -gt 0) { throw "digits input must only contain digits" }

    return (
        0 .. ($DLen - $Span) | ForEach-Object {
            Get-Product -Factors $DigitArray[$_ .. ($_ + $Span - 1)]
        } | Measure-Object -Maximum
    ).Maximum

    <#
    .SYNOPSIS
    Get the largest product in a given span of long sequence of digits.
    
    .DESCRIPTION
    Given a string made up by number and a span lenght, find the largest product of all the number in that span.
    
    .PARAMETER Digits
    The string digits to be analyzed.

    .PARAMETER Span
    The lenght of the span.
    
    .EXAMPLE
    Get-LargestSeriesProduct -Digits "63915" -Span 3
    Return: 162
    #>
}
