Function Invoke-PrimeFactors() {
    [CmdletBinding()]
    Param(
        [Int64]$Number
    )

    $Result = @()
    $Candidate = 2
    while ($Number -gt 1) {
        while ($Number % $Candidate -eq 0) {
            $Result += , $Candidate
            $Number /= $Candidate
        }
        $Candidate++
    }
    Return $Result
    <#
    .SYNOPSIS
    Calculate the prime factors of a given natural number.

    .DESCRIPTION
    Check if the number is divisible by 2. If it is, divide it by 2 and add 2 to the list of factors.
    If it is not, increment the number by 1 and check if it is divisible by 3. If it is, divide it by 3 and add 3 to the list of factors.

    .PARAMETER Number
    The number to factorize.

    .EXAMPLE
    Invoke-PrimeFactors -Number 12
    #>
}
