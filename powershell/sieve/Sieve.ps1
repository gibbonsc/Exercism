Function Invoke-Sieve() {
    [CmdletBinding()]
    Param(
        [int]$Limit
    )

    if ($Limit -lt 2) { return $null }
    $Raw = 2..$Limit
    $Primes = @()
    $Index = 0
    do {
        $Prime = $Raw[$Index++]
        $Primes += , $Prime
        $Unmarked = $Primes
        while ($Index -lt $Raw.Length) {
            if ($Raw[$Index] % $Prime -ne 0) {
                $Unmarked += , $Raw[$Index]
            }
            $Index++
        }
        $Raw = $Unmarked
        $Index = $Primes.Count
    } while ($Unmarked.Count -gt $Index)
    return $Primes

    <#
    .SYNOPSIS
    Create a program that implements the Sieve of Eratosthenes algorithm to find prime numbers.

    .DESCRIPTION
    The function take a limit (inclusive) and use the Sieve of Eratosthenes to find all the prime numbers between 2 and the limit.
    To use the Sieve of Eratosthenes, you first create a list of all the numbers between 2 and your given number.
    Then you repeat the following steps:
    1. Find the next unmarked number in your list. This is a prime number.
    2. Mark all the multiples of that prime number as composite (not prime).

    Repeating these steps until you've gone through every number in your list.
    At the end, all the unmarked numbers are prime.

    .PARAMETER Limit
    The limit (inclusive) to find all the prime numbers.

    .EXAMPLE
    Invoke-Sieve -Limit 10
    Return: @(2, 3, 5, 7)
     #>
}