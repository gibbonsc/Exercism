Function Invoke-PerfectNumbers() {
    [CmdletBinding()]
    Param(
        [Int64]$Number
    )

    if ($Number -lt 1) { throw "error: Classification is only possible for positive integers." }
    $Sum = 0
    for ($i = 1; $i -le $Number / 2; $i++) {
        if ($Number % $i -eq 0) {
            $Sum += $i
        }
    }
    Return ($Sum -lt $Number) ? "deficient" : ( ($Sum -gt $Number) ? "abundant" : "perfect" )
    <#
    .SYNOPSIS
    Determine if a number is perfect, abundant, or deficient based on Nicomachus' (60 - 120 CE) classification scheme for natural numbers.

    .DESCRIPTION
    Calculate the aliquot sum of a number: the sum of its positive divisors not including the number itself.
    Compare the sum to the original number.
    Determine the classification: perfect, abundant, or deficient.

    .PARAMETER Number
    The number to perform the classification on.

    .EXAMPLE
    Invoke-PerfectNumbers -Number 12
    #>
}
