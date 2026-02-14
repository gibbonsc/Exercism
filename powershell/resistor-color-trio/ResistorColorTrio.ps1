$Script:ColorCode = [ordered]@{
    "black"=0
    "brown"=1
    "red"=2
    "orange"=3
    "yellow"=4
    "green"=5
    "blue"=6
    "violet"=7
    "grey"=8
    "white"=9
}
Function Get-ResistorLabel() {
    [CmdletBinding()]
    Param(
        [string[]]$Colors
    )
    $Units = $Script:ColorCode[$Colors[1]]
    $Tens = 10 * $Script:ColorCode[$Colors[0]]
    $Value = $Tens + $Units
    $Magnitude = $Script:ColorCode[$Colors[2]]
    $MagnitudeMod3 = $Magnitude % 3
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

    Return "$Value ${MetricPrefix}ohms"
    <#
    .SYNOPSIS
    Implement a function to get the label of a resistor with three color-coded bands.

    .DESCRIPTION
    Given an array of colors from a resistor, decode their resistance values and return a string represent the resistor's label.

    .PARAMETER Colors
    The array repesent the 3 colors from left to right.

    .EXAMPLE
    Get-ResistorLabel -Colors @("red", "white", "blue")
    Return: "29 megaohms"
     #>
}