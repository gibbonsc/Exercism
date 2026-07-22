Function Get-Products() {
    [CmdletBinding()]
    Param(
        [int]$Min,
        [int]$Max,
        [switch]$Largest
    )

    if ($Max -lt $Min) { throw "Cannot validate argument on parameter 'Max'" }
    $Found = $false
    if ($Largest) {
        $Value = 0
        $Factors = @()
        for ($i = $Max; $i -ge $Min; $i--) {
            for ($j = $Max; $j -ge $i; $j--) {
                $P = $i * $j
                if ($Found -and $P -lt $Value) { continue }
                $PStr = [string]$P
                $PCh = [char[]]$Pstr
                [Array]::Reverse($PCh)
                $PStrRev = -join $PCh
                if ($PStr -ne $PStrRev) { continue }
                $Found = $true
                if ($P -gt $Value) {
                    $Value = $P
                    $Factors = @()
                }
                if ($P -eq $Value) {
                    $Factors = , @($i, $j) + $Factors
                }
            }
        }
        if ($Found) { return @{ Value = $Value; Products = $Factors } }
    }
    else {  # search for smallest
        $Value = $Max * $Max
        $Factors = @()
        for ($i = $Min; $i -le $Max; $i++) {
            for ($j = $Min; $j -le $i; $j++) {
                $P = $i * $j
                if ($Found -and $P -gt $Value) { continue }
                $PStr = [string]$P
                $PCh = [char[]]$Pstr
                [Array]::Reverse($PCh)
                $PStrRev = -join $PCh
                if ($PStr -ne $PStrRev) { continue }
                $Found = $true
                if ($P -lt $Value) {
                    $Value = $P
                    $Factors = @()
                }
                if ($P -eq $Value) {
                    $Factors += , @($j, $i)
                }
            }
        }
        if ($Found) { return @{ Value = $Value; Products = $Factors } }
    }

    <#
    .SYNOPSIS
    Detect palindrome products in a given range.

    .DESCRIPTION
    A palindromic number is a number that remains the same when its digits are reversed.
    For example, `121` is a palindromic number but `112` is not.

    Given a range of numbers, find the largest and smallest palindromes which
    are products of two numbers within that range.

    Your solution should return the largest and smallest palindromes, along with the factors of each within the range.
    If the largest or smallest palindrome has more than one pair of factors within the range, then return all the pairs.

    .PARAMETER Min
    The minimum value of the range to find palindrome products.
    Min can't be larger than Max.
    
    .PARAMETER Max
    The maximum value of the range to find palindrome products.
    Max can't be smaller than Min. Parameter contrainst should be placed on this parameter.

    .PARAMETER Largest
    A switch parameter, present to return the largest palindrome.
    If not present then default behavior of the function should be return the smallest palindrome.

    .EXAMPLE
    Get-Products -Min 1 -Max 9
    Returns : @{ Value = 1; Products = @( @(1, 1)) }

    Get-Products -Min 1 -Max 9 -Largest
    Returns : @{ Value = 9; Products = @( @(1, 9), @(3, 3)) }
    #>
}
