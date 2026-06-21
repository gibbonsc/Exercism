<#
  Uses [Hashtable] types with [int] values for multisets.
  Example: multiset @(1, 1, 4) as a [Hashtable] is @{ 1 = 2; 4 = 1 }

  Very slow brute-force algorithm. It tries all possible subsets of books!
  Passes the Pester unit tests, but it takes over 12 minutes to do so on
  my workstation! Submitting it anyway...
#>

Function Get-NonEmptySubsets {
    # generate power set of @(1,2,3,4,5), but without @(), as a [Hashtable]
    $Set = 1..5
    for ($Mask = 1; $Mask -lt 32; $Mask++) {
        $Subset = [Hashtable]::new()
        for ($i = 0; $i -lt $Set.Count; $i++) {
            if ($Mask -band (1 -shl $i)) {
                $Subset[$Set[$i]] = 1
            }
        }
        Write-Output $Subset
    }
}

Function Test-SubsetOfMultiSet {
    Param(
        [Hashtable]$S,
        [Hashtable]$MultiSet
    )
    foreach ($K in $S.Keys) {
        if (-not $MultiSet.ContainsKey($K)) { return $false }
        if ($MultiSet[$k] -lt $S[$K]) { return $false }
    }
    $true
}

Function Get-SetPartitions {
    Param([Hashtable]$MultiSet)
    $Subsets = Get-NonEmptySubsets
    Function RecurseBack {
        Param(
            [Hashtable]$RemainingMultiSet,
            [Hashtable[]]$ProgressPartitions,
            [int]$StartIndex
        )
        if ($RemainingMultiSet.Count -ne 0) {
            for ($i = $StartIndex; $i -lt $Subsets.Count; $i++) {
                $Subset = $Subsets[$i]
                if (Test-SubsetOfMultiSet $Subset $RemainingMultiSet) {
                    $NextRemaining = @{}
                    foreach ($K in $RemainingMultiSet.Keys) {
                        if ($Subset.ContainsKey($K)) {
                            $D = $RemainingMultiSet[$K] - $Subset[$K]
                            if (0 -lt $D) {
                                $NextRemaining[$K] = $D
                            }
                        }
                        else {
                            $NextRemaining[$K] = $RemainingMultiSet[$K]
                        }
                    }
                    $NextPartitions = @()
                    foreach ($P in $ProgressPartitions) {
                        $NextPartitions += , $P
                    }
                    $NextPartitions += $Subset
                    RecurseBack $NextRemaining $NextPartitions $i
                }
            }
        }
        else {
            return , $ProgressPartitions
        }
    }
    return , @(RecurseBack $Multiset -ProgressPartitions @() -StartIndex 0)
}

Function Assert-Range {
    Param(
        [Parameter(Mandatory, ValueFromPipeline)][int[]]$Values,
        [Parameter(Mandatory)][int]$LB,
        [Parameter(Mandatory)][int]$UB
    )
    foreach ($V in $Values) {
        if ($V -lt $LB -or $UB -lt $V) { return $false }
    }
    return $true
}

Function Get-Total() {
    [CmdletBinding()]
    Param(
        [ValidateScript({ Assert-Range -Values $_ -LB 1 -UB 5 })]
        [int[]]$Books
    )
    # convert input into a [Hashtable] "multi-set".
    $BookCountHash = @{}
    foreach ($B in $Books) {
        $BookCountHash[$B]++
    }

    # survey all set "partitions" of the multi-set
    $Candidates = Get-SetPartitions -MultiSet $BookCountHash

    $DiscountPct = 0, 0, 0.05, 0.10, 0.20, 0.25
    $Prices = @()
    foreach ($Candidate in $Candidates) {
        $Price = 0.0
        foreach ($Set in $Candidate) {
            $Price += 8.0 * $Set.Count * (1.0 - $DiscountPct[$Set.Count])
        }
        $Prices += , $Price
    }
    return ($Prices | Measure-Object -Minimum).Minimum

    <#
    .SYNOPSIS
    Implement a function to calculate the price of books BASE_PRICEd on different combinations.

    .DESCRIPTION
    Given a basket of books, calculate the price of any conceivable shopping basket (containing only books of the same series), giving as big a discount as possible.

    One copy of any of the five books costs $8.
    If, however, you buy two different books, you get a 5% discount on those two books.
    If you buy 3 different books, you get a 10% discount.
    If you buy 4 different books, you get a 20% discount.
    If you buy all 5, you get a 25% discount.

    Note that if you buy four books, of which 3 are different titles, you get a 10% discount on the 3 that form part of a set, but the fourth book still costs $8.
    
    .PARAMETER Books
    An array of int, each represent an entry in a popular 5 books series.
    Parameter restraint : integer from 1 to 5 (inclusive).

    .EXAMPLE
    Get-Total -Books @(1, 1, 1, 1, 1) # no discount here
    Returns: 40

    Get-Total -Books @(1, 2, 3, 4, 5) # 25% discount applied here
    Returns: 30
    #>
}
