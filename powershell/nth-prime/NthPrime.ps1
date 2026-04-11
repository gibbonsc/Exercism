Function Get-NPrimes() {
    <#
    .SYNOPSIS
    Given a quota n, generate list of the first n primes.

    .DESCRIPTION
    Generates the first n prime numbers.

    .PARAMETER Quota
    The number of primes to generate.

    .EXAMPLE
    Get-NPrimes -Quota 6
    Returns: @(2, 3, 5, 7, 11, 13)
    #>

    [CmdletBinding()]
    Param(
        [Int64]$Quota
    )

    # $Primes = @(2,3)  # runs rather slow ... instead,
    # use .NET collection type; faster than PowerShell's array type,
    # and can preallocate enough space for the quota.
    $Primes = [System.Collections.Generic.List[int]]::new($Quota)
    if ($Quota -ge 1) { $Primes.Add(2) }
    if ($Quota -ge 2) { $Primes.Add(3) }

    $C = 2  # counter, will go up to quota
    $Sixes = 1  # check "multiples of six plus or minus 1" candidates
    $Side = -1
    while ($C -lt $Quota) {
        # candidate to check, presume it's prime until shown otherwise
        $Next = 6 * $Sixes + $Side
        $Found = $true
        for ($i = 2; $i -lt $C; $i++) {
            $Divisor = $Primes[$i]
            if ($Divisor * $Divisor -gt $Next) {
                # exhausted potential prime divisors
                break
            }
            if (($Next % $Divisor) -eq 0) {
                # not a prime
                $Found = $false
                break
            }
        }
        if ($Found) {
                $C++
                $Primes.Add($Next)  # faster than $Primes += , $Next
                Write-Debug "Prime $Next at index $C"
        }
        # ready next candidate
        $Side *= -1
        if ($Side -eq -1) { $Sixes++ }
    }
    $Primes
}

Function Get-NthPrime() {
    <#
    .SYNOPSIS
    Given a number n, determine what the nth prime is.

    .DESCRIPTION
    By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that the 6th prime is 13.

    .PARAMETER Number
    The number of the prime to return.

    .EXAMPLE
    Get-NthPrime -Number 5
    #>

    [CmdletBinding()]
    Param(
        [Int64]$Number
    )

    if ($Number -eq 0) {
        throw "error: there is no zeroth prime"
    }
    else {
        $GeneratedPrimes = Get-NPrimes $Number
        return $GeneratedPrimes[-1]
    }
}
