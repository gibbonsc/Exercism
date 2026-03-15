Function Get-Proverb() {
    [CmdletBinding()]
    Param(
        [string[]]$Data
    )
    $Size = $Data.Length
    switch ($Size) {
        0 { return ""}
        default {
            $Noun1 = $Data[0]
            $Result = ""
            $Stinger = "And all for the want of a ${Noun1}."
            for ($i = 1; $i -lt $Size; $i++) {
                $Noun2 = $Noun1
                $Noun1 = $Data[$i]
                $Result += "For want of a $Noun2 the $Noun1 was lost.`r`n"
            }
            return $Result + $Stinger
        }
    }

    <#
    .SYNOPSIS
    Given a list of inputs, generate the relevant proverb.

    .DESCRIPTION
    Take a list of inputs and output the full text of a proverbial rhyme base on those inputs.

    .PARAMETER Data
    The list of inputs to generate the proverb.

    .EXAMPLE
    Get-Proverb -Data @("nail", "shoe", "horse", "rider", "message", "battle", "kingdom")

    @"
    For want of a nail the shoe was lost.
    For want of a shoe the horse was lost.
    For want of a horse the rider was lost.
    For want of a rider the message was lost.
    For want of a message the battle was lost.
    For want of a battle the kingdom was lost.
    And all for the want of a nail.
    "@
    #>
}