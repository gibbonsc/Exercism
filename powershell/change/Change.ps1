Function Get-Gcd {
    [CmdletBinding()]
    Param(
        [uint]$A,
        [uint]$B
    )
    if ($A -eq 0) { return $B }
    if ($B -eq 0) { return $A }
    $K = 0
    while ((($A -bor $B) -band 1) -eq 0) { $A = $A -shr 1; $B = $B -shr 1; $K++ }
    while (($A -band 1) -eq 0) { $A = $A -shr 1 }
    while ($B -gt 0) {
        while (($B -band 1) -eq 0) { $B = $B -shr 1 }
        if ($B -lt $A) { $A, $B = $B, $A }
        $B -= $A
    }
    return $A -shl $K
}

Function Get-Change() {
    [CmdletBinding()]
    Param(
        [int[]]$Coins,
        [int]$Target
    )
    if ($Target -eq 0) { return , @(); }
    if ($Target -lt 0) { throw "Target can't be negative"}
    $DenominationCount = $Coins.Count
    if (0 -eq $DenominationCount) { throw "Empty Coins array" }
    $SortedCoins = $Coins | Sort-Object
    $Gcd = $SortedCoins[0]
    if ($DenominationCount -gt 1) {
        foreach ($I in 1..($DenominationCount - 1)) {
            $Gcd = Get-Gcd $Gcd $SortedCoins[$I]
        }
    }
    if ($Target % $Gcd -ne 0 -or $Target -lt $SortedCoins[0] ) {
        throw "Can't make change with given coins"
    }

    $Max1 = [int]::MaxValue - 1
    $MinCs = @(0)
    $I = $Gcd
    for ($I = $Gcd; $I -le $Target; $I += $Gcd) {
        $C = $SortedCoins | ForEach-Object {
            $Coin = $_
            if ($Coin -le $I) {
                $MinCs[($I - $Coin)/$Gcd] + 1
            }
            else {
                $Max1
            }
        }
        $MinC = ($C | Measure-Object -Minimum).Minimum
        $MinCs += , $MinC
    }

    $Coins = @()
    $Disbursing = $Target
    while ($Disbursing -gt 0) {
        foreach ($Coin in $SortedCoins) {
            if (
                $Coin -le $Disbursing -and
                ($MinCs[$Disbursing] - 1 -eq $MinCs[$Disbursing - $Coin])
            ) { $Coins += , $Coin; $Disbursing -= $Coin; break }
        }
    }
    return $Coins

    <#
    .SYNOPSIS
    Determine the fewest number of coins to be given to a customer such that the sum of the coins' value would equal the correct amount of change.
    
    .DESCRIPTION
    Given a change target and an array of coins with different values, find the fewest number of coins can to be used to make the change.
    Return the array of coins (if possible) in ascending order.
    
    .PARAMETER Coins
    The array of coin values.

    .PARAMETER Target
    The amount of change needed to be made.
    
    .EXAMPLE
    Get-Change -Coins @(1, 2, 5, 10, 25) -Target 55
    Return: @(5, 25, 25)
    #>
}