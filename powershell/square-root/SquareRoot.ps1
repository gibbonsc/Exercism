Function Get-SquareRoot() {
    [CmdletBinding()]
    Param(
        [int]$Radicand
    )
    # Bisection search algorithm (more satisfying)
    $Lb, $Ub = 0, ($Radicand + 1)  # search interval
    while ($Lb -ne ($Ub - 1)) {
        # use remainder to properly _integer_ divide by two
        if (($Lb + $Ub) % 2 -eq 0) {
            $Candidate = ($Lb + $Ub) / 2
        }
        else {
            $Candidate = ($Lb + $Ub - 1) / 2
        }
        # adjust search interval endpoint
        if ($Candidate * $Candidate -le $Radicand){
            $Lb = $Candidate
        }
        else {
            $Ub = $Candidate
        }
    }
    Return $Lb

    <#
    .SYNOPSIS
    Given a natural radicand, return its square root.
    
    .DESCRIPTION
    The function takes a positive integer and return its square root value.

    .PARAMETER Radicand
    The number to get its square root.
    
    .EXAMPLE
    Get-SquareRoot -Radicand 25
    Retuns: 5
    #>
}