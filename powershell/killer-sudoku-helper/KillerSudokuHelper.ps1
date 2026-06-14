Function Get-DistinctPartitions {
    <#
    .SYNOPSIS
    Generate distinct partitions (addends) of an integer.

    .DESCRIPTION
    Given an integer, a sequence size, and an upper limit (and an optional lower limit),
    generate the sequences that sum to exactly that integer, constrained such that each
    addend in a sequence is distinct and is within the specified limits.

    .PARAMETER Total
    The sum of all partitions

    .PARAMETER Parts
    The cardinality of the partition sequence

    .PARAMETER Limit
    Partitions' upper bound

    .PARAMETER MinVal
    Partitions' lower (default: 1)

    .EXAMPLE
    Get-DistinctPartitions -Total 8 -Size 3 -Limit 5
    Return: @( @(1, 2, 5), @(1, 3, 4) )
    #>
    [CmdletBinding()]
    Param(
        [int]$Total,
        [int]$Parts,
        [int]$Limit,
        [int]$MinVal = 1
    )

    if (0 -eq $Parts -and 0 -eq $Total) {
        return , @()
    }

    if (0 -eq $Parts -or $Total -lt 0 -or $MinVal -gt $Limit) {
        return @()
    }

    $MinRemainingSum = $Parts * $MinVal + ($Parts * ($Parts - 1)) / 2
    if ($MinRemainingSum -gt $Total) {
        return @()
    }

    $MaxVal = $Limit - $Parts + 1
    $FloorCalc = [int][Math]::Floor([double]$Total / $Parts)
    if ($FloorCalc -lt $MaxVal) { $MaxVal = $FloorCalc }

    for ($X = $MinVal; $X -le $MaxVal; $X++) {
        [object[]]$ReturnedSubPartitions = @(
            Get-DistinctPartitions ($Total - $X) ($Parts - 1) $Limit ($X + 1)
        )
        foreach ($SubPartition in $ReturnedSubPartitions) {
            $CompletedPartition = , $X + $SubPartition
            Write-Output -NoEnumerate $CompletedPartition
        }
    }
}

Function Invoke-KillerSudokuHelper() {
    [CmdletBinding()]
    Param(
        [int]$Sum,
        [int]$Size,
        [int[]]$Exclude
    )

    if (1 -eq $Size) {
        return , @(@($Sum))
    }
    elseif (45 -eq $Sum -and 9 -eq $Size)
    {
        return , @(@(1, 2, 3, 4, 5, 6, 7, 8, 9))
    }
    else {
        $Candidates = @( Get-DistinctPartitions $Sum $Size 9 )
        foreach ($Candidate in $Candidates) {
            $Verified = $true
            foreach ($Forbid in $Exclude) {
                if ($Forbid -in $Candidate) {
                    $Verified = $false; break
                }
            }
            if ($Verified) {
                Write-Output -NoEnumerate $Candidate
            }
        }
    }

    <#
    .SYNOPSIS
    Implement a function to help solve killer sudoku.

    .DESCRIPTION
    Given a cage of certain size, a sum and an array of excluded number, follow the rules and find all possible combinations to fill the cage.
    To make the output of your program easy to read, the combinations it returns must be sorted.

    For example:
    7, [][][], No exclusion => Only possible solution is [1][2][4]
    [1][1][5], [1][3][3], [2][2][3] are all in violation of the "A digit may only occur once in a cage" rule.

    .PARAMETER Sum
    The target sum: total of all number in a cage.

    .PARAMETER Size
    The size of the cage: total cells available for the sum.

    .PARAMETER Exlude
    An array of number that should be excluded from consideration for the sum.

    .EXAMPLE
    Invoke-KillerSudokuHelper -Sum 5 -Size 2 -Exclude @(1)
    Return: @( ,@(2, 3))
    #>
}