Function Get-Rhyme() {
    [CmdletBinding()]
    Param(
        [int]$Start,
        [int]$End
    )
    $Features = "zero-indexed feature",
        "house that Jack built.",
        "malt", "rat", "cat", "dog",
        "cow with the crumpled horn",
        "maiden all forlorn",
        "man all tattered and torn",
        "priest all shaven and shorn",
        "rooster that crowed in the morn",
        "farmer sowing his corn",
        "horse and the hound and the horn"
    $Verbs = "verb-zeroed", "lay in",
        "ate", "killed", "worried", "tossed",
        "milked", "kissed", "married", "woke",
        "kept", "belonged to"
    $Result = @()
    $Start .. $End | ForEach-Object {
        $Verse = $_
        $Line = "This is the " + $Features[$_]
        if ($Verse -gt 1) {
            ($Verse - 1) .. 1 | ForEach-Object {
                $Line += " that " + $Verbs[$_]
                $Line += " the " + $Features[$_]
            }
        }
        $Result += , $Line
    }
    Return $Result -join "`n"

    <#
    .SYNOPSIS
    Recite the nursery rhyme 'This is the House that Jack Built'.

    .DESCRIPTION
    Given the start verse and the end verse, return a string reciting the rhyme from that range.

    .PARAMETER Start
    The start verse.

    .PARAMETER End
    The end verse.

    .EXAMPLE
    Get-Rhyme -Start 1 -End 2
    Return:
    @"
    This is the house that Jack built.
    This is the malt that lay in the house that Jack built.
    "@
     #>
}