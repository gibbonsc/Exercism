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

Class TwoBucket {
    [int[]] $Capacities = 0,0
    [int] $FirstFill

    TwoBucket([int] $size1, [int] $size2, [string] $start) {
        $this.Capacities[0] = $size1
        $this.Capacities[1] = $size2
        if ($start -eq "one") {
            $this.FirstFill = 0
        }
        else {
            $this.FirstFill = 1
        }
    }

    [object] Measure([int] $target) {
        if ($this.Capacities[0] -eq $this.Capacities[1]) {
            throw "Two buckets can't be of the same size"
        }
        if ($this.Capacities[0] -lt $target -and
            $this.Capacities[1] -lt $target) {
            throw "Target is impossible to reach"
        }
        if ($target %
            (Get-Gcd $this.Capacities[0] $this.Capacities[1]) -ne 0) {
            throw "Target is impossible to reach"
        }

        # first action: fill the designated starting bucket
        [int[]] $State = 0,0
        $ActionCounter = 1
        $State[$this.FirstFill] = $this.Capacities[$this.FirstFill]
        # prepare for potential pour action
        $PourTurn = $true
        $PourDst = 1 - $this.FirstFill

        if ($this.Capacities[$PourDst] -eq $target) {
            # just fill the other bucket immediately and be done
            $State[$PourDst] = $this.Capacities[$PourDst]
            ++$ActionCounter
        }

        while ($State[0] -ne $target -and
            $State[1] -ne $target) {
            if ($PourTurn) {
                $Delta = $this.Capacities[$PourDst] - $State[$PourDst]
                if ($State[$this.FirstFill] -lt $Delta) {
                    $Delta = $State[$this.FirstFill]
                }
                $State[$PourDst] += $Delta
                $State[$this.FirstFill] -= $Delta
                $PourTurn = $false  # prepare to fill/empty next turn
            }
            else {  # "Fill/Empty" turn instead of "Pour" turn
                if ($State[$PourDst] -lt $this.Capacities[$PourDst]) {
                    # fill first bucket again
                    $State[$this.FirstFill] =
                        $this.Capacities[$this.FirstFill]
                }
                else {
                    # empty destination bucket
                    $State[$PourDst] = 0
                }
                $PourTurn = $true # prepare to pour next turn
            }
            ++$ActionCounter
        }
        $Result = [PSCustomObject]@{
            Moves = $ActionCounter
            GoalBucket = "one"
            OtherBucket = [int]0
        }
        if ($State[0] -eq $target) {
            $Result.OtherBucket = $State[1]
        }
        else {
            $Result.GoalBucket = "two"
            $Result.OtherBucket = $State[0]
        }
        return $Result
    }
}

<#
.SYNOPSIS
    Given two buckets of different size and which bucket to fill first, determine how many actions are required to measure an exact number of liters by strategically transferring fluid between the buckets.

.DESCRIPTION
    Please read the rules of how to implement the solution in instructions.
    
    Your task here is to implement a class to solve for the solution.
    The class should take in : size of bucket 1, size of bucket 2, and which bucket to start with "one" or "two"
    The class should have the Measure method that take in the target, and if possible return an object for the result.

    If it is not possible to reach the target, please throw an error.
    
.EXAMPLE
    $buckets = [TwoBucket]::new(6, 7, "one")
    $buckets.Measure(5) | Format-List

    Returns:
    Moves       : 4
    GoalBucket  : one
    OtherBucket : 7
#>
