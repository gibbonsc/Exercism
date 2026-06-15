Function Invoke-Say() {
    [CmdletBinding()]
    Param(
        [int64]$Number
    )

    if (0 -gt $Number -or $Number -gt 999999999999) {
        throw "Cannot validate argument on parameter 'Number'"
    }
    if ($Number -eq 0) {
        return "zero"
    }

    $Digits = "{0:d12}" -f $Number
    $Units = @(
        "", "one", "two", "three", "four",
        "five", "six", "seven", "eight", "nine"
    )
    $Teens = @(
        "ten", "eleven", "twelve", "thirteen", "fourteen",
        "fifteen", "sixteen", "seventeen", "eighteen", "ninteeen"
    )
    $Tens = @(
        "", "", "twenty", "thirty", "forty",
        "fifty", "sixty", "seventy", "eighty", "ninety"
    )
    $Result = @()
    for ($p = 0; $p -lt 12; $p += 3) {
        $sh = [int]$Digits[$p] - [int][char]'0'
        $st = [int]$Digits[$p+1] - [int][char]'0'
        $su = [int]$Digits[$p+2] - [int][char]'0'
        $Period = @()
        if ($sh -ne 0) {
            $Period += @( $Units[$sh], "hundred")
        }
        if ($st -eq 1) {
            $Period += $Teens[$su]
        }
        else {
            if ($st -ge 2) {
                if ($su -ne 0) {
                    $Period += , ($Tens[$st] + "-" + $Units[$su])
                }
                else {
                    $Period += $Tens[$st]
                }
            }
            elseif ($su -ne 0) {
                $Period += , $Units[$su]
            }
        }
        if ($Period.Count -gt 0) {
            if ($p -eq 6) {
                $Period += , "thousand"
            }
            elseif ($p -eq 3) {
                $Period += , "million"
            }
            elseif ($p -eq 0) {
                $Period += , "billion"
            }
        }
        $Result += $Period
    }
    return $Result -join " "
    <#
    .SYNOPSIS
    Given a number from 0 to 999,999,999,999, spell out that number in English.

    .DESCRIPTION
    Implement a program to convert a number in a specific range to a string of that number in English.

    .PARAMETER Number
    An int in the range of 0 - 999,999,999,999 to be converted into english words.

    .EXAMPLE
    Invoke-Say -Number 12345
    Returns: "twelve thousand three hundred forty-five"
    #>
}
