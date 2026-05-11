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
    <#
    .SYNOPSIS
    Given input integers A, B find greatest common factor Gcd(A,B)

    .DESCRIPTION
    Given two integers, find their greatest common divisor.
    Algorithm adapted from Stein's Binary GCF Algorithm,
    https://www.geeksforgeeks.org/dsa/steins-algorithm-for-finding-gcd/

    .PARAMETER A
    First integer

    .PARAMETER B
    Second integer

    .EXAMPLE
    Get-Gcd -A 396 -B 252
    Returns: 36
    #>
}

Function Expand-EuclidPythagoreanTriplet {
    [CmdletBinding()]
    Param(
        [uint]$M,
        [uint]$N,
        [uint]$K
    )
    if ($M -le $N ) { throw "Error: M must be greater than N" }
    if ((Get-Gcd $M $N) -gt 1) { throw "Error: M, N must be coprime" }
    $MSq = $M * $M
    $NSq = $N * $N
    $Result = @(
        ($K * $M * $N),
        ($K * ($MSq - $NSq) / 2),
        ($K * ($MSq + $NSq) / 2)
        ) | Sort-Object
    return $Result
    <#
    .SYNOPSIS
    Given two relatively prime integers and a multiplier, return their corresponding Pythagorean Triple.

    .DESCRIPTION
    Given relatively prime odd integers M, N, M > N > 0, and integer multiplier K,
    return Pythagorean Triple A, B, C (A² + B² = C² such that A < B < C)
    per Euler's formula A = K*(M² - N²), B = K*M*N*2, C = K*(M² + N²);
    https://en.wikipedia.org/wiki/Pythagorean_triple

    .PARAMETER M
    First integer

    .PARAMETER N
    Second integer, less than and relatively prime to M

    .PARAMETER K
    Multiplier

    .EXAMPLE
    Expand-EuclidPythagoreanTriplet -M 3 -N 1 -K 1
    Returns: @(3, 4, 5)
    #>
}

Function Get-PythagoreanTriplet() {
    [CmdletBinding()]
    Param(
        [int]$Sum
    )
    $Result = @()
    for ($n = 1; $true; $n += 2) {
        for ($m = $n + 2; $true; $m += 2) {
            if ((Get-Gcd $m $n) -gt 1) { continue }
            $k = 1
            while ($true) {
                $a, $b, $c = Expand-EuclidPythagoreanTriplet $m $n $k
                if ($a + $b + $c -eq $Sum) {
                    Write-Debug "Found m=$m, n=$n, k=$k : $a, $b, $c : $($a+$b+$c)"
                    $Result += , @($a, $b, $c)
                    break
                }
                # triangle inequality constraint on $k
                if ($c -ge $Sum / 2) { break }
                $k++
            }
            # triangle inequality constraint on $m
            if (2*$m*$n -ge $Sum / 2) { break }
        }
        # triangle inquality constraint for consecutive odd $n, $m
        if (2 * ($n+1) * ($n+2) -gt $Sum ) { break }
    }
    return $Result | Sort-Object -Property { $_[0] }

    # simple brute-force algorithm was too slow for larger $Sum ...
    # $Result = @()
    # for ($a = 3; $a -lt $Sum / 2; $a++) {
    #     for ($b = $a + 1; $b -lt $Sum / 2; $b++) {
    #         $c = $Sum - $a - $b
    #         if ($a * $a + $b * $b -eq $c * $c) {
    #             $Result += , @($a, $b, $c)
    #         }
    #     }
    # }
    # return $Result

    <#
    .SYNOPSIS
    Given input integer N, find all Pythagorean triplets for which 'a + b + c = N'.

    .DESCRIPTION
    Given an integer, find all the possible Pythagorean triplets whose sum is equal to that integer.
    Return the array of Pythagorean triplets in sorted ascending order.

    A Pythagorean triplet is a set of three natural numbers, {a, b, c}, for which:
    a² + b² = c²
    a < b < c

    .PARAMETER Number
    The sum of a Pythagorean triplet

    .EXAMPLE
    Get-PythagoreanTriplet -Sum 12
    Return: @( ,@(3, 4, 5))
    #>
}
