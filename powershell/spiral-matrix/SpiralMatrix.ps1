Function Get-SpiralMatrix() {
    [CmdletBinding()]
    Param(
        [int]$Size
    )
    if ($Size -eq 0) { Return , @() }
    $Compass = @( @(0, 1), @(1, 0), @(0, -1), @(-1, 0) )  # E, S, W, N
    $Grid = @()
    foreach ($Row in @(1..$Size)) {
        $Grid += , @(1..$Size)  # initialize rows with top row's values
    }
    $Row, $Col = 1, ($Size - 1)  # begin below top row
    $Bear, $Step, $Span = 1, 0, ($Size - 2)  # begin bearing south
    $Val = $Size  # begin with top row's last value
    while ($Span -ge 0) {
        $Val++
        $Grid[$Row][$Col] = $Val  # place a value
        if (++$Step -gt $Span) {  # stepped far enough?
            $Bear = ($Bear + 1) % 4  # turn, bearing right
            $Step = 0  # begin counting a new span
            if ($Bear%2 -eq 1) {  # vertical bearing?
                $Span--  # shrink span
            }
        }
        $Row += $Compass[$Bear][0]  # step forward
        $Col += $Compass[$Bear][1]
    }
    Return @($Grid)

    <#
    .SYNOPSIS
    Implement a function to generate a spiral matrix.

    .DESCRIPTION
    Given the size, return a square matrix of numbers in spiral order.
    The matrix should be filled with natural numbers, starting from 1 in the top-left corner, increasing in an inward, clockwise spiral order

    .PARAMETER Size
    Size of the matrix.

    .EXAMPLE
    Get-SpiralMatrix -Size 2
    Return: @(
        @(1,2),
        @(4,3)
    )
    #>
}