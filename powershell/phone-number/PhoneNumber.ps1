Function Get-PhoneNumber() {
    [CmdletBinding()]
    Param(
        [string]$Number,
        [switch]$Pretty
    )

    if ($Number -match "[A-Za-z]") {
        throw "Letters not permitted"
    }
    elseif ($Number -match "[!@#]") {
        throw "Punctuations not permitted"
    }

    [char[]]$Chars = $Number.ToCharArray()
    [Array]::Reverse($Chars)
    $Numerals = ""
    foreach ($C in $Chars) {
        if ([char]'0' -le $C -and $C -le [char]'9') {
            $Numerals = [string]$C + $Numerals
        }
    }

    if ($Numerals.Length -lt 10) {
        throw "Number can't be fewer than 10 digits"
    }
    elseif ($Numerals.Length -gt 11) {
        throw "Number can't be more than 11 digits"
    }
    elseif ($Numerals.Length -eq 11 -and $Numerals[0] -ne '1') {
        throw "11 digits must start with 1"
    }

    $Numerals = $Numerals.Substring($Numerals.Length - 10, 10)

    $FirstAreaCodeDigit = $Numerals[0]
    $FirstExchangeDigit = $Numerals[3]
    if ($FirstAreaCodeDigit -in @('0','1')) {
        throw "Area code can't start with $FirstAreaCodeDigit"
    }
    elseif ($FirstExchangeDigit -in @('0','1')) {
        throw "Exchange code can't start with $FirstExchangeDigit"
    }

    $Pretty ?
        "($($Numerals.Substring(0,3)))" +
        "-$($Numerals.Substring(3,3))" +
        "-$($Numerals.Substring(6,4))" :
        $Numerals

    <#
    .SYNOPSIS
    Clean up user-entered phone numbers so that they can be sent SMS messages.

    .DESCRIPTION
    Given a phone number string, check if it's a valid phone number that complied with the NANP system.
    Return the cleaned number string if it's valid, otherwise throw the relevant error.
    Also provide user the option to print out the number in pretty format.

    .PARAMETER Number
    The phone number string to be processed.

    .PARAMETER Pretty
    Provide optional flag that will print out the phone number in pretty format: (Area)-Exchange-Number
    
    .EXAMPLE
    Get-PhoneNumber -Number '+1 (223) 456-7890'
    return: '2234567890'

    Get-PhoneNumber -Number '555.888.9999' -Pretty
    return: '(555)-888-9999'
    #>
}