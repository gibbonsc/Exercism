Function ConvertFrom-SevenSegment {
    [CmdletBinding()]param([string[]]$FourByThree)
    $Templates = @(
        # abcdefg, _||_||_
        "_||_|| ", # 0
        " ||    ", # 1
        "_| _| _", # 2
        "_||_  _", # 3
        " ||  |_", # 4
        "_ |_ |_", # 5
        "_ |_||_", # 6
        "_||    ", # 7
        "_||_||_", # 8
        "_||_ |_" # 9
    )
    $MarksToMatch = "" + $FourByThree[0][1] +
    $FourByThree[1][2] + $FourByThree[2][2] +
    $FourByThree[2][1] + $FourByThree[2][0] +
    $FourByThree[1][0] + $FourByThree[1][1]
    $BlanksToMatch = "" + $FourByThree[0][0] +
    $FourByThree[0][2] + $FourByThree[3]
    $Numeral = $Templates.IndexOf($MarksToMatch)
    if (" " * 5 -ne $BlanksToMatch -or -1 -eq $Numeral) {
        $Result = "?"
    }
    else {
        $Result = [string]$Numeral
    }
    return $Result
}

Function Invoke-OCR {
    [CmdletBinding()]
    Param(
        [string[]]$Grid
    )
    if (0 -ne ($Grid.Count % 4)) {
        throw "Number of input lines is not a multiple of four"
    }
    foreach ($Line in $Grid) {
        if (0 -ne ($Grid[$Line].Length % 3)) {
            throw "Number of input columns is not a multiple of three"
        }
    }

    $Lines = $Grid.Count / 4

    $Result = ""
    for ($r = 0; $r -lt $Lines; $r++) {
        $NumbersPerLine = $Grid[$r * 4].Length / 3
        $Acc = ""
        if ($r -gt 0) {
            $Result += ","
        }
        for ($c = 0; $c -lt $NumbersPerLine; $c++) {
            $Acc += ConvertFrom-SevenSegment @(
                $Grid[$r * 4].Substring($c * 3, 3),
                $Grid[$r * 4 + 1].Substring($c * 3, 3),
                $Grid[$r * 4 + 2].Substring($c * 3, 3),
                $Grid[$r * 4 + 3].Substring($c * 3, 3)
            )
        }
        $Result += , $Acc
    }
    return $Result

    <#
    .SYNOPSIS
    Implement a function for OCR (optical character recognition) to convert it into a number.

    .DESCRIPTION
    Given a grid of pipes, underscores, and spaces, determine which number is represented, or whether it is garbled.
    Return the number string or "?" if it is garbled.

    .PARAMETER Grid
    An array of strings, each represent a row of the grid.

    .EXAMPLE
    $lines = (
        "   ",
        "  |",
        "  |",
        "   "
    )
    Convert-OCR -Grid $lines
    Return: "1"
    #>
}
