Function Invoke-TwelveDays() {
    [CmdletBinding()]
    Param(
        [int]$Start,
        [int]$End
    )
    $Ordinals = "zero-index","first","second","third","fourth","fifth",
        "sixth","seventh","eighth","ninth","tenth","eleventh","twelfth"
    $Burdens = "zero-index","a Partridge in a Pear Tree",
        "two Turtle Doves", "three French Hens", "four Calling Birds",
        "five Gold Rings", "six Geese-a-Laying",
        "seven Swans-a-Swimming", "eight Maids-a-Milking",
        "nine Ladies Dancing", "ten Lords-a-Leaping",
        "eleven Pipers Piping", "twelve Drummers Drumming"
    $Verses = ""
    $Start .. $End | ForEach-Object {
        $Index = $_
        $Ordinal = $Ordinals[$Index]
        $Verses += "On the $Ordinal day of Christmas"
        $Verses += " my true love gave to me:"
        for ($i = $Index; $i -ge 1; $i-- ) {
            if ($i -eq 1 -and $Index -gt 1) {
                $Verses += " and"
            }
            $Verses += " " + $Burdens[$i]
            if ($i -ne 1) {
                $Verses += ","
            }
        }
        $Verses += "."
        if ($Index -ne $End) { $Verses += "`n" }
    }
    Write-Output $Verses

    <#
    .SYNOPSIS
    Recite the lyrics of the song: "The Twelve Days of Christmas" based on given verses.

    .DESCRIPTION
    Given a start verse and an end verse, return the string lyric of the English Christmas carol "The Twelve Days of Christmas".
    Each subsequent verse of the song builds on the previous verse.

    .PARAMETER Start
    The starting verse.

    .PARAMETER End
    The ending verse.

    .EXAMPLE
    Invoke-TwelveDays -Start 1 -End 1
    Return: "On the first day of Christmas my true love gave to me: a Partridge in a Pear Tree."
    #>
}