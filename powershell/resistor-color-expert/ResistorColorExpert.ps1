$Script:ColorCode = [ordered]@{
    black=0
    brown=1
    red=2
    orange=3
    yellow=4
    green=5
    blue=6
    violet=7
    grey=8
    white=9
}
$Script:TolerancePercentageCode = @{
    grey = 0.05
    violet = 0.1
    blue = 0.25
    green = 0.5
    brown = 1
    red = 2
    gold = 5
    silver = 10
}
Function Get-ResistorLabel() {
    [CmdletBinding()]
    Param(
        [string[]]$Colors
    )

    switch ($Colors.Count) {
        1 {
            Return "$($ColorCode[0]) ohms"
        }
        4 {
            $Units = $Script:ColorCode[$Colors[1]]
            $Tens = 10 * $Script:ColorCode[$Colors[0]]
            $Magnitude = $Script:ColorCode[$Colors[2]]
            $TolerancePercentage = $Script:TolerancePercentageCode[$Colors[3]]
            $MagnitudeMod3 = $Magnitude % 3
            $Value = $Tens + $Units
            if ($Magnitude -ge 8) {
                $MetricPrefix = "giga"
            }
            elseif ($Magnitude -ge 5) {
                $MetricPrefix = "mega"
            }
            elseIf ($Magnitude -ge 2) {
                $MetricPrefix = "kilo"
            }
            else {
                $MetricPrefix = ""
            }
            if ($MagnitudeMod3 -eq 1) {
                $Value *= 10
            }
            elseif ($MagnitudeMod3 -eq 2) {
                $Value /= 10
            }
        }
        5 {
            $Units = $Script:ColorCode[$Colors[2]]
            $Tens = 10 * $Script:ColorCode[$Colors[1]]
            $Hundreds = 100 * $Script:ColorCode[$Colors[0]]
            $Magnitude = $Script:ColorCode[$Colors[3]]
            $TolerancePercentage = $Script:TolerancePercentageCode[$Colors[4]]
            $MagnitudeMod3 = $Magnitude % 3
            $Value = $Hundreds + $Tens + $Units
            if ($Magnitude -ge 6) {
                $MetricPrefix = "giga"
            }
            elseif ($Magnitude -gt 3) {
                $MetricPrefix = "mega"
            }
            elseIf ($Magnitude -gt 0) {
                $MetricPrefix = "kilo"
            }
            else {
                $MetricPrefix = ""
            }
            if ($MagnitudeMod3 -eq 1) {
                $Value /= 100
            }
            elseif ($MagnitudeMod3 -eq 2) {
                $Value /= 10
            }
        }
    }

    Return "$Value ${MetricPrefix}ohms ±${TolerancePercentage}%"
    <#
    .SYNOPSIS
    Implement a function to get the label of a resistor from its color-coded bands.

    .DESCRIPTION
    Given an array of 1, 4 or 5 colors from a resistor, decode their resistance values and return a string represent the resistor's label.

    .PARAMETER Colors
    The array represent the colors from left to right.

    .EXAMPLE
    Get-ResistorLabel -Colors @("red", "black", "green", "red")
    Return: "2 megaohms ±2%"

    Get-ResistorLabel -Colors @("blue", "blue", "blue", "blue", "blue")
    Return: "666 megaohms ±0.25%"
     #>
}