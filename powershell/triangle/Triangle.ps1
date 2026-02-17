Enum Triangle {
    DEGENERATE
    ISOSCELES
    EQUILATERAL
    SCALENE
}

Function Get-Triangle() {
    [CmdletBinding()]
    Param (
        [double[]]$Sides
    )
    if (($Sides[0] -le 0) -or ($Sides[1] -le 0) -or ($Sides[2] -le 0)) {
        Throw "All side lengths must be positive."
    }
    $SortedSides = $Sides | Sort-Object
    if (($SortedSides[0]+$SortedSides[1]) -lt $SortedSides[2]) {
        Throw "Side lengths violate triangle inequality."
    }
    if (($SortedSides[0] -eq $SortedSides[1]) -and
        ($SortedSides[1] -eq $SortedSides[2])) {
        return [Triangle]::EQUILATERAL
    }
    elseif (($SortedSides[0] -eq $SortedSides[1]) -or
        ($SortedSides[1] -eq $SortedSides[2])) {
        return [Triangle]::ISOSCELES
    }
    # elseif (($SortedSides[0]+$SortedSides[1]) -eq $SortedSides[2]) {
    #     return [Triangle]::DEGENERATE
    # }  # don't; test case expects @(4, 7, 1) to be scalene, not degenerate
    else {
        return [Triangle]::SCALENE
    }
    <#
    .SYNOPSIS
    Determine if a triangle is equilateral, isosceles, or scalene.

    .DESCRIPTION
    Given 3 sides of a triangle, return the type of that triangle if it is a valid triangle.
    
    .PARAMETER Sides
    The lengths of a triangle's sides.

    .EXAMPLE
    Get-Triangle -Sides @(1,2,3)
    Return: [Triangle]::SCALENE
    #>
}
