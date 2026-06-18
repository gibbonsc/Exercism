Function Invoke-FoodChain() {
    [CmdletBinding()]
    Param(
        [int]$Start,
        [int]$End
    )
    if (0 -eq $End) {
        $End = $Start
    }
    $WriggleClause = "wriggled and jiggled and tickled inside her."
    $Fodder = @(
        "`u{1f3b5}",
        "fly", "spider", "bird", "cat",
        "dog", "goat", "cow", "horse"
    )
    $Rhymes = @(
        "`u{1f3b6}",
        "I don't know why she swallowed the fly.",
        ("It " + $WriggleClause),
        "How absurd to swallow a bird!",
        "Imagine that, to swallow a cat!",
        "What a hog, to swallow a dog!",
        "Just opened her throat and swallowed a goat!",
        "I don't know how she swallowed a cow!",
        "She's dead, of course!"
    )
    $Verse = $Start
    $VerseText = ""
    while ($Verse -le $End) {
        $VerseText += "I know an old lady who swallowed a "
        $VerseText += $Fodder[$Verse] + ".`n"
        $VerseText += $Rhymes[$Verse]
        if ($Verse -eq 8) {
            break
        }
        for ($LinkClause = $Verse; $LinkClause -gt 1; $LinkClause--) {
            $VerseText += "`n"
            $VerseText += "She swallowed the "
            $VerseText += $Fodder[$LinkClause]
            $VerseText += " to catch the "
            $VerseText += $Fodder[$LinkClause - 1]
            switch($LinkClause) {
                2 {
                    $VerseText += ".`n" + $Rhymes[1]
                    break
                }
                3 {
                    $VerseText += " that " + $WriggleClause
                    break
                }
                default {
                    $VerseText += "."
                }
            }
        }
        $VerseText += " Perhaps she'll die."
        if ($Verse -lt $end) { $VerseText += "`n`n" }
        $Verse++
    }
    Return $VerseText
    <#
    .SYNOPSIS
    Generate the lyrics of the song 'I Know an Old Lady Who Swallowed a Fly'.

    .DESCRIPTION
    Given a start verse and an end verse, generate a string lyric from the song 'I Know an Old Lady Who Swallowed a Fly'.

    .PARAMETER Start
    The starting verse. This parameter is mandatory.

    .PARAMETER End
    The ending verse. This parameter is optional.
    If not provided, it should be the same as starting verse.

    .EXAMPLE
    Invoke-FoodChain -Start 2
    Return:
    @"
    I know an old lady who swallowed a spider.
    It wriggled and jiggled and tickled inside her.
    She swallowed the spider to catch the fly.
    I don't know why she swallowed the fly. Perhaps she'll die.
    "@
    #>
}
