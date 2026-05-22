Function Expand-Verse {
    param([ValidateRange(1,10)][int]$Num)
    $Cardinals = "No", "One", "Two", "Three", "Four",
        "Five", "Six", "Seven", "Eight", "Nine", "Ten"
    $Result = "$($Cardinals[$Num]) green bottle"
    if ($Num -ne 1) { $Result += "s" }
    $Result += " hanging on the wall,`n"
    $Result += $Result
    $Result += "And if one green bottle should accidentally fall,`n"
    $Result += "There'll be "
    $Result += $Cardinals[$Num - 1].ToLower()
    $Result += " green bottle"
    if ($Num -ne 2) { $Result += "s" }
    $Result += " hanging on the wall."
    return $Result
}

Function Get-Lyric() {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)][ValidateRange(1,10)]
        [int]$Start,
        [ValidateRange(1,10)]
        [int]$Take = 1
    )
    if ($Start -lt $Take) { throw "You can't take more bottle than what you started with." }
    $Text = ""
    for ($i = $Start; $i -gt ($Start - $Take); $i-- ) {
        $Text += Expand-Verse($i)
        if ($i -gt ($Start - $Take + 1)) { $Text += "`n`n" }
    }
    return $text

    <#
    .SYNOPSIS
    Recite the lyrics to that popular children's repetitive song: Ten Green Bottles.

    .DESCRIPTION
    Given a start bottles and a number of bottles to be taken away, return a string made of lyric from the song Ten Green Bottles.
    Note that not all verses are identical.

    .PARAMETER Start
    Number of bottles to start with, in range 1-10

    .PARAMETER Take
    Number of bottles to be taken away, in range 1-10
    Taken bottles can't be larger than starting bottles.

    .EXAMPLE
    Get-Lyric -Start 7
    Return:
    @"
    Seven green bottles hanging on the wall,
    Seven green bottles hanging on the wall,
    And if one green bottle should accidentally fall,
    There'll be six green bottles hanging on the wall.
    "@"
    #>
}
