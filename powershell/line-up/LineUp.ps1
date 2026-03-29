Function Get-LineUp() {
    [CmdletBinding()]
    Param(
        [string]$Name,
        [int]$Number
    )
    # General ordinal suffix rules
    switch ($Number % 10) {
        1 { $Suffix = "st" }
        2 { $Suffix = "nd" }
        3 { $Suffix = "rd" }
        default { $Suffix = "th" }
    }
    # Specific exceptions eleventh, twelfth, thirteenth
    if (11 -le ($Number % 100) -and ($Number % 100) -le 13) { $Suffix = "th" }
    $Result = "$Name,"
    $Result += " you are the $Number$Suffix"
    $Result += " customer we serve today. Thank you!"
    Return $Result

    <#
    .SYNOPSIS
    Produce a greeting for customer in a line.
    
    .DESCRIPTION
    Given a name and a number, your task is to produce a sentence using that name and that number as an ordinal numeral.

    .PARAMETER Name
    String represents name of the customer.

    .PARAMETER Number
    Integer represents the order of the customer in line. (1 to 999)

    .EXAMPLE
    Get-LineUp -Name "Exercism" -Number 1
    Returns: "Exercism, you are the 1st customer we serve today. Thank you!"
    #>
}
