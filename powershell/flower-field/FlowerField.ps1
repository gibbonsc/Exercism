Function Get-Annotate() {
    [CmdletBinding()]
    Param(
        [string[]]$Garden
    )

    # input validation
    $RowCount = $Garden.Count
    if (0 -eq $RowCount) { return $null }
    $ColCount = $Garden[0].Length
    if ($Garden[0] -notmatch '^[* ]*$') {
        throw 'There is a weed (invalid character) in the Garden'
    }
    # cast Garden string array to FlowerField char jagged matrix
    $FlowerField = [char[][]]::new($RowCount)
    $FlowerField[0] = $Garden[0].ToCharArray()
    # continue casting/validating remaining rows, if any
    if ($RowCount -gt 1) {
        for ($r = 1; $r -lt $RowCount; $r++) {
            if ($Garden[$r].Length -ne $ColCount) {
                throw "Garden is not rectangular"
            }
            if ($Garden[0] -notmatch '^[* ]*$') {
                throw 'There is a weed (invalid character) in the Garden'
            }
            $FlowerField[$r] = $Garden[$r].ToCharArray()
        }
    }
    # one last validation: are all the garden strings empty?
    if (0 -eq $ColCount) { Write-Output -NoEnumerate $Garden }
    else {
        # calculate and place proximity digits
        $Token = [char]'*'  # (a pretty flower)
        $Zero = [int][char]'0'
        for ($r = 0; $r -lt $RowCount; $r++) {
            for ($c = 0; $c -lt $ColCount; $c++) {
                # skip cells that already contain a token
                if ($Token -eq $FlowerField[$r][$c]) { continue }
                $right, $below, $left, $above = ($c+1),($r+1),($c-1),($r-1)
                $A = 0  # accumulator
                if (0 -lt $r) {
                    if (0 -lt $c) {
                        if ($Token -eq $FlowerField[$above][$left]) { $A++ }
                    }
                    if ($Token -eq $FlowerField[$above][$c]) { $A++ }
                    if ($c -lt $ColCount - 1) {
                        if ($Token -eq $FlowerField[$above][$right]) { $A++ }
                    }
                }
                if ($c -lt $ColCount - 1) {
                    if ($Token -eq $FlowerField[$r][$right]) { $A++ }
                }
                if ($r -lt $RowCount - 1) {
                    if (0 -lt $c) {
                        if ($Token -eq $FlowerField[$below][$left]) { $A++ }
                    }
                    if ($Token -eq $FlowerField[$below][$c]) { $A++ }
                    if ($c -lt $ColCount - 1) {
                        if ($Token -eq $FlowerField[$below][$right]) { $A++ }
                    }
                }
                if (0 -lt $c) {
                    if ($Token -eq $FlowerField[$r][$left]) { $A++ }
                }
                if (0 -lt $A) {
                    $FlowerField[$r][$c] = [char]($Zero + $A)
                }
            }
        }
        # cast jagged matrix back into string array
        return $FlowerField | ForEach-Object { -join $_ }
    }

    <#
    .SYNOPSIS
    Add the flower counts to a completed Flower Field board.

    .DESCRIPTION
    Flower Field is a popular game where the user has to find the flowers using numeric hints that indicate how many flowers are directly adjacent (horizontally, vertically, diagonally) to a square.

    In this exercise you have to create some code that counts the number of flowers adjacent to a given empty square and replaces that square with the count.

    The board is a rectangle composed of blank space (' ') characters.
    A flower is represented by an asterisk (`*`) character.

    If a given space has no adjacent flowers at all, leave that square blank.

    .PARAMETER Garden
    An array of string, each representing a row of the garden.
    This parameter should be validated to check that only blank spaces and asterisks are in it.

    .EXAMPLE
    Get-Annotate Garden @(" *** ")
    Returns: @("1***1")
    #>
}