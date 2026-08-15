enum HandRank {
    HighCard
    Pair
    TwoPair
    ThreeOfAKind
    Straight
    Flush
    FullHouse
    FourOfAKind
    StraightFlush
}

Function Get-CardRank {
    [CmdletBinding()]
    Param([string]$Card)
    $Rank = 10
    if ($Card.SubString(0, 2) -ne "10") {
        switch ($Card.SubString(0, 1)) {
            "J" { $Rank = 11; break }
            "Q" { $Rank = 12; break }
            "K" { $Rank = 13; break }
            "A" { $Rank = 14; break }
            default {
                $Rank = [int]($Card.SubString(0, 1))
            }
        }
    }
    return $Rank
}

Function Get-HandRank {
    [CmdletBinding()]
    Param([string[]]$Cards)
    [string[]] $SortedCards = $Cards |
        Sort-Object -Property { Get-CardRank $_ }
    [int[]] $SortedCardRanks = @(
        (Get-CardRank $SortedCards[0]),
        (Get-CardRank $SortedCards[1]),
        (Get-CardRank $SortedCards[2]),
        (Get-CardRank $SortedCards[3]),
        (Get-CardRank $SortedCards[4])
    )
    $Diffs = @(
        ($SortedCardRanks[1] - $SortedCardRanks[0]),
        ($SortedCardRanks[2] - $SortedCardRanks[1]),
        ($SortedCardRanks[3] - $SortedCardRanks[2]),
        ($SortedCardRanks[4] - $SortedCardRanks[3])
    )
    $Straight =
    $Diffs[0] -eq 1 -and
    $Diffs[1] -eq 1 -and
    $Diffs[2] -eq 1 -and
    ($Diffs[3] -eq 1 -or $Diffs[3] -eq 9)  # ace might be low
    $SortedCardSuits = @(
        $SortedCards[0].SubString($SortedCards[0].Length - 1, 1),
        $SortedCards[1].SubString($SortedCards[1].Length - 1, 1),
        $SortedCards[2].SubString($SortedCards[2].Length - 1, 1),
        $SortedCards[3].SubString($SortedCards[3].Length - 1, 1),
        $SortedCards[4].SubString($SortedCards[4].Length - 1, 1)
    )
    $Flush =
    $SortedCardSuits[0] -eq $SortedCardSuits[1] -and
    $SortedCardSuits[0] -eq $SortedCardSuits[2] -and
    $SortedCardSuits[0] -eq $SortedCardSuits[3] -and
    $SortedCardSuits[0] -eq $SortedCardSuits[4]

    if ($Straight -and $Flush) {
        return [HandRank]::StraightFlush
    }
    elseif (
        $SortedCardRanks[1] -eq $SortedCardRanks[2] -and
        $SortedCardRanks[2] -eq $SortedCardRanks[3] -and
        ($SortedCardRanks[0] -eq $SortedCardRanks[1] -or
        $SortedCardRanks[3] -eq $SortedCardRanks[4])
    ) {
        return [HandRank]::FourOfAKind
    }
    elseif (
        $SortedCardRanks[0] -eq $SortedCardRanks[1] -and
        $SortedCardRanks[3] -eq $SortedCardRanks[4] -and
        ($SortedCardRanks[1] -eq $SortedCardRanks[2] -or
        $SortedCardRanks[2] -eq $SortedCardRanks[3])
    ) {
        return [HandRank]::FullHouse
    }
    elseif ($Flush) { return [HandRank]::Flush }
    elseif ($Straight) { return [HandRank]::Straight }
    elseif (
        ($SortedCardRanks[0] -eq $SortedCardRanks[1] -and
        $SortedCardRanks[1] -eq $SortedCardRanks[2]) -or
        $SortedCardRanks[2] -eq $SortedCardRanks[3] -and
        ($SortedCardRanks[1] -eq $SortedCardRanks[2] -or
        $SortedCardRanks[3] -eq $SortedCardRanks[4]) 
    ) {
        return [HandRank]::ThreeOfAKind
    }
    elseif (
        ($SortedCardRanks[0] -eq $SortedCardRanks[1] -and
        ($SortedCardRanks[2] -eq $SortedCardRanks[3] -or
        $SortedCardRanks[3] -eq $SortedCardRanks[4])) -or
        ($SortedCardRanks[1] -eq $SortedCardRanks[2] -and
        $SortedCardRanks[3] -eq $SortedCardRanks[4])
    ) {
        return [HandRank]::TwoPair
    }
    elseif (
        $SortedCardRanks[0] -eq $SortedCardRanks[1] -or
        $SortedCardRanks[1] -eq $SortedCardRanks[2] -or
        $SortedCardRanks[2] -eq $SortedCardRanks[3] -or
        $SortedCardRanks[3] -eq $SortedCardRanks[4]
    ) {
        return [HandRank]::Pair
    }
    else {
        return [HandRank]::HighCard
    }
}

Function Get-HandCardRanks {
    [CmdletBinding()]
    Param([string[]]$Cards)
    [string[]] $SortedCards = $Cards |
        Sort-Object -Property { Get-CardRank $_ }
    [int[]] $SortedCardRanks = @(
        (Get-CardRank $SortedCards[0]),
        (Get-CardRank $SortedCards[1]),
        (Get-CardRank $SortedCards[2]),
        (Get-CardRank $SortedCards[3]),
        (Get-CardRank $SortedCards[4])
    )
    # certain hands sort card ranks differently
    $HandRank = Get-HandRank $Cards
    if ($HandRank -in @([HandRank]::Straight, [HandRank]::StraightFlush)) {
        if ($SortedCardRanks[4] -eq 14) {
            # in lowest straight, ace ranks low instead of high
            $SortedCardRanks = @(
                1,
                $SortedCardRanks[0],
                $SortedCardRanks[1],
                $SortedCardRanks[2],
                $SortedCardRanks[3]
            )
        }
    }
    elseif ($HandRank -eq [HandRank]::FourOfAKind) {
        if ($SortedCardRanks[0] -eq $SortedCardRanks[3]) {
            # re-sort if kicker has higher rank than quad
            $SortedCardRanks = @(
                $SortedCardRanks[4],
                $SortedCardRanks[0],
                $SortedCardRanks[1],
                $SortedCardRanks[2],
                $SortedCardRanks[3]
            )
        }
    }
    elseif ($HandRank -eq [HandRank]::FullHouse) {
        if ($SortedCardRanks[0] -eq $SortedCardRanks[2]) {
            # re-sort if pair higher ranked than trio
            $SortedCardRanks = @(
                $SortedCardRanks[3],
                $SortedCardRanks[4],
                $SortedCardRanks[0],
                $SortedCardRanks[1],
                $SortedCardRanks[2]
            )
        }
    }
    # elseif ($HandRank -eq [HandRank]::TwoPair) {  # not necessary?
    #     if (
    #         $SortedCardRanks[0] -eq $SortedCardRanks[1] -and
    #         $SortedCardRanks[2] -eq $SortedCardRanks[3]
    #     ) {  # re-sort if kicker higher than either pair
    #         $SortedCardRanks = @(
    #             $SortedCardRanks[4],
    #             $SortedCardRanks[0],
    #             $SortedCardRanks[1],
    #             $SortedCardRanks[2],
    #             $SortedCardRanks[3]
    #         )
    #     }
    #     elseif (
    #         $SortedCardRanks[0] -eq $SortedCardRanks[1] -and
    #         $SortedCardRanks[3] -eq $SortedCardRanks[4]
    #     ) {  # re-sort if kicker higher than one pair, but not the other
    #         $SortedCardRanks = @(
    #             $SortedCardRanks[2],
    #             $SortedCardRanks[0],
    #             $SortedCardRanks[1],
    #             $SortedCardRanks[3],
    #             $SortedCardRanks[4]
    #         )
    #     }
    # }
    return $SortedCardRanks;
}

Function Get-BestHand() {
    [CmdletBinding()]
    Param(
        [string[]]$Hands
    )
    $BestIndex = @(0)
    $BestCards = $Hands[0] -split " " |
        Sort-Object -Property { Get-CardRank $_ }
    $BestRank = Get-HandRank $BestCards
    for ($i = 1; $i -lt $Hands.Count; $i++) {
        $Cards = $Hands[$i] -split " " |
            Sort-Object -Property { Get-CardRank $_ }
        $Rank = Get-HandRank $Cards
        if ($BestRank -lt $Rank) {
            $BestIndex = $i
            $BestCards = $Cards
            $BestRank = $Rank
        }
        elseif ($BestRank -eq $Rank) {
            $BestCardRanks = Get-HandCardRanks $BestCards
            $CardRanks = Get-HandCardRanks $Cards
            $Tie = $true
            foreach ($j in (4..0)) {
                if ($CardRanks[$j] -lt $BestCardRanks[$j]) {
                    $Tie = $false
                    break
                }
                elseif ($CardRanks[$j] -gt $BestCardRanks[$j]) {
                    $BestIndex = @($i)
                    $BestCards = $Cards
                    $Tie = $false
                    break
                }
            }
            if ($Tie) { $BestIndex += , $i } 
            
        }
    }
    return $Hands[$BestIndex]

    <#
    .SYNOPSIS
    Pick the best hand(s) from a list of poker hands.

    .DESCRIPTION
    Given an array of poke hands, pick out the best (highest value) hand(s) and return them in an array.

    .PARAMETER Hands
    An array of string(s), each representing a poker hand.

    .EXAMPLE
    Get-BestHand -Hands @("AS QS KS 10S JS", "JS AH QD 10S KC")
    Return: @("AS QS KS 10S JS")
    #>
}
