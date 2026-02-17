Function Invoke-Darts() {
    [CmdletBinding()]
    Param(
        [Double]$X,
        [Double]$Y
    )
    
    $DistSq = $X * $X + $Y * $Y
    if ($DistSq -gt 100) { Return 0 }  # miss
    elseif ($DistSq -gt 25) { Return 1 }  # outer ring
    elseif ($DistSq -gt 1) { Return 5 }  # middle ring
    else { return 10 }  # inner circle
    <#
    .SYNOPSIS
    Calculate the earned points in a single toss of a Darts game.

    .DESCRIPTION
    Take a coordinate of a point and calculate the distance from the center of the dartboard.
    Then depending on the distance and which concentric circle the point lies in, return the
    number of points earned.

    .PARAMETER X
    The X coordinate of the dart.

    .PARAMETER Y
    The Y coordinate of the dart.

    .EXAMPLE
    Invoke-Darts -X 0 -Y 10
    #>
}
