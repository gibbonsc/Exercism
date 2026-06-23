<#
  Uses [Hashtable] types with [int] values for multisets.
  Example: multiset @(1, 1, 4) as a [Hashtable] is @{ 1 = 2; 4 = 1 }

  Very slow brute-force algorithm. It tries all possible subsets of books!
  Passes the Pester unit tests, but it takes over 12 minutes to do so on
  my workstation! Submitting it anyway...
#>

Function Get-NonEmptySubsets {
    # generate power set of @(1,2,3,4,5), but without @(), as a [Hashtable[]]
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

Function Get-TotalBruteForce() {
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

    $DiscountPct = 0d, 0d, 0.05d, 0.10d, 0.20d, 0.25d
    $Prices = @()
    foreach ($Candidate in $Candidates) {
        $Price = 0.0
        foreach ($Set in $Candidate) {
            $Price += 8.0d * $Set.Count * (1.0d - $DiscountPct[$Set.Count])
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

Function Get-TotalGreedy() {
    [CmdletBinding()]
    Param(
        [ValidateScript({ Assert-Range -Values $_ -LB 1 -UB 5 })]
        [int[]]$Books
    )
    # Only quantities of books in a multiset affect discount rates.
    # For this exercise, books themselves are fungible,
    # so just work with the sorted counts.
    $BookGroups = $Books | Group-Object
    $GroupCounts = $BookGroups | ForEach-Object { $_.Count } | Sort-Object

    # This "greedy" algorithm passes each Exercism test (and a few others),
    #   but I can't yet prove that it accurately produces a minimum price
    #   for *all* possible inputs.

    $PriceAcc = 0.0d
    while ($GroupCounts.Count -gt 0) {
        # look for and apply the best discounts, either one set at time
        #   or with a known optimal bargain set of sets.
        switch ($GroupCounts.Count) {
            5 {
                # Are sorted counts shaped for three sets of four?
                # Check for monotonically increasing counts of the three
                #   least selected titles, followed by three or more each of
                #   the most selected titles.
                $ThreeOfFour =
                    $GroupCounts[0] -lt $GroupCounts[1] -and
                    $GroupCounts[1] -lt $GroupCounts[2] -and
                    $GroupCounts[3] -ge 3 -and
                    $GroupCounts[4] -ge 3
                if ($ThreeOfFour) {
                    $PriceAcc += (25.6d * 3)  # three sets of four
                    $UpdatedCounts = @(
                        ($GroupCOunts[0] - 1),
                        ($GroupCOunts[1] - 2),
                        ($GroupCOunts[2] - 3),
                        ($GroupCOunts[3] - 3),
                        ($GroupCOunts[4] - 3)
                    )
                    break
                }
                # Are sorted counts shaped for two sets of four?
                # Check whether there are twice or more as many of the three
                #   most selected titles than of the two least selected titles
                $TwoOfFour =
                    $GroupCounts[0] -eq $GroupCounts[1] -and
                    $GroupCounts[2] -ge $GroupCounts[0] * 2 -and
                    $GroupCounts[3] -ge $GroupCounts[0] * 2 -and
                    $GroupCounts[4] -ge $GroupCounts[0] * 2
                if ($TwoOfFour) {
                    $PriceAcc += (25.6d * 2)  # two sets of four
                    $UpdatedCounts = @(
                        ($GroupCounts[0] - 1),
                        ($GroupCounts[1] - 1),
                        ($GroupCOunts[2] - 2),
                        ($GroupCounts[3] - 2),
                        ($GroupCounts[4] - 2)
                    )
                }
                else {
                    $PriceAcc += 30.0d  # one set of five
                    $UpdatedCounts = @(
                        ($GroupCounts[0] - 1),
                        ($GroupCounts[1] - 1),
                        ($GroupCOunts[2] - 1),
                        ($GroupCounts[3] - 1),
                        ($GroupCounts[4] - 1)
                    )
                }
                break
            }
            # remaining cases could probably be optimized for quantity
            4 {
                $PriceAcc += 25.6d  # one set of four
                $UpdatedCounts = @(
                    ($GroupCounts[0] - 1),
                    ($GroupCounts[1] - 1),
                    ($GroupCounts[2] - 1),
                    ($GroupCounts[3] - 1)
                )
                break
            }
            3 {
                $PriceAcc += 21.6d  # one set of three
                $UpdatedCounts = @(
                    ($GroupCounts[0] - 1),
                    ($GroupCounts[1] - 1),
                    ($GroupCounts[2] - 1)
                )
                break
            }
            2 {
                $PriceAcc += 15.2d  # one set of two
                $UpdatedCounts = @(
                    ($GroupCounts[0] - 1),
                    ($GroupCounts[1] - 1)
                )
                break
            }
            1 {
                $PriceAcc += 8.0d  # one book at full price
                $UpdatedCounts = @(
                    $GroupCounts[0] - 1
                )
                break
            }
        }
        $GroupCounts = $UpdatedCounts |
            Where-Object { $_ -gt 0 } |
            Sort-Object
    }
    return [double]$PriceAcc

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

Function Test-BruteForceVsGreedy {
    Param([int[]]$Books)
    
    $BruteForceResult = Get-TotalBruteForce -Books $Books
    $GreedyResult = Get-TotalGreedy -Books $Books

    if ($GreedyResult -ne $BruteForceResult) {
        Write-Warning "MISMATCH: Books={0} BruteForce={1} Greedy={2}" -f
            ($Books -join ','), $BruteForceResult, $GreedyResult
    }
}

Function Search-BruteForceVsGreedy {
    Param(
        [int]$MaxTitleCount,
        [int]$MinMultisetCount,
        [int]$MaxMultisetCount
    )
    if ($MinMultisetCount -gt $MaxMultisetCount) {throw "Max<Min"}
    for ($c1 = 0; $c1 -le $MaxTitleCount; $c1++) {
    for ($c2 = $c1; $c2 -le $MaxTitleCount; $c2++) {
    for ($c3 = $c2; $c3 -le $MaxTitleCount; $c3++) {
    for ($c4 = $c3; $c4 -le $MaxTitleCount; $c4++) {
    for ($c5 = $c4; $c5 -le $MaxTitleCount; $c5++) {
        $Books = @(1) * $c1 + @(2) * $c2 + @(3) * $c3 + @(4) * $c4 + @(5) * $c5
        if ($Books.Count -ge $MinMultisetCount -and $Books.Count -le $MaxMultisetCount) {
            [Console]::CursorLeft = 0
            Write-Host -NoNewline (("Testing {0}" + ("  " * $MaxMultisetCount)) -f ($Books -join ","))
            Test-BruteForceVsGreedy -Books $Books
        }
    }}}}}
    Write-Host
}
