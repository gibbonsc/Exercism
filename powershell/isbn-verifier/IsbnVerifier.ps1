Function Test-Isbn() {
    [CmdletBinding()]
    Param(
        [string]$Isbn
    )

    $DigitsOnly = $Isbn -replace '-',''
    if ($DigitsOnly.Length -ne 10) { return $false }
    $Checksum = 0
    for ($i = 0; $i -lt 9; $i++) {
        $Digit = $DigitsOnly[$i]
        if ($Digit -lt [char]'0' -or [char]'9' -lt $Digit) { return $false }
        else {
            $CheckSum += [int]($Digit - [char]'0') * (10 - $i)
        }
    }
    $Digit = $DigitsOnly[9]  # check digit
    if ([char]'X' -eq $Digit) { $CheckSum += 10 }
    elseif ($Digit -lt [char]'0' -or [char]'9' -lt $Digit) { return $false }
    else {
        $CheckSum += [int]($Digit - [char]'0')
    }
    return ($CheckSum % 11 -eq 0)
    <#
    .SYNOPSIS
    Determine if an ISBN is valid or not.
    
    .DESCRIPTION
    Given a string the function should check if the provided string is a valid ISBN-10.
    
    .PARAMETER Isbn
    The ISBN to check
    
    .EXAMPLE
    Test-Isbn -Isbn "3-598-21508-8"
    
    Returns: $true
    #>
}
