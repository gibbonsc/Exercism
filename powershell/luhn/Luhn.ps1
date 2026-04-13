Function Test-Luhn() {
    [CmdletBinding()]
    Param(
        [string]$Value
    )

    $LuhnTable = @{
        0 = 0; 1 = 2; 2 = 4; 3 = 6; 4 = 8;
        5 = 1; 6 = 3; 7 = 5; 8 = 7; 9 = 9
    }
    $Digits = @()
    foreach ($d in [char[]]$Value) {
        if ($d -eq [char]' ') { continue }
        elseif ([char]'0' -le $d -and $d -le [char]'9') {
            $Digits += , [int]($d - [char]'0')
        }
        else {
            return $false
        }
    }
    if (1 -ge $Digits.Length) { return $false }
    [Array]::Reverse($Digits)
    $Sum = $LuhnValue = 0
    for ($i = 0; $i -lt $Digits.Length; $i++) {
        if (0 -eq ($i % 2)) {
            $LuhnValue = $Digits[$i]
        }
        else {
            $LuhnValue = $LuhnTable[$Digits[$i]]
        }
        $Sum += $LuhnValue
    }
    0 -eq ($Sum % 10)

    <#
    .SYNOPSIS
    Determine if a number is valid per the Luhn formula.
    
    .DESCRIPTION
    The Luhn formula is a simple checksum formula used to validate a variety of identification numbers,
    such as credit card numbers and Canadian Social Insurance Numbers.
    
    .PARAMETER Value
    The number to validate
    
    .EXAMPLE
    Test-Luhn -Value "59"
    
    Returns: $true
    #>
}
