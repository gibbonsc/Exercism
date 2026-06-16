Function Get-SpiralMatrix() {
    [CmdletBinding()]
    Param(
        [int]$Size
    )
    if ($Size -eq 0) { Return , @() }
    $Compass = @( @(0, 1), @(1, 0), @(0, -1), @(-1, 0) )
    $Grid = @()
    foreach ($Row in @(1..$Size)) {
        $Grid += , @(1..$Size)
    }
    $Bear, $Step, $Row, $Col, $Span = 1, 0, 1, ($Size - 1), ($Size - 2)
    $Val = $Size
    while ($Val -lt $Size * $Size) {
        $Val++
        $Grid[$Row][$Col] = $Val
        if (++$Step -gt $Span) {
            $Step = 0
            $Bear = ($Bear + 1) % 4
            if ($Bear%2 -eq 1) {
                $Span--
            }
        }
        $Row += $Compass[$Bear][0]
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