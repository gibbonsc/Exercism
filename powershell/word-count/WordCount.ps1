Function Get-WordCount() {
    [CmdletBinding()]
    Param(
        [string]$Phrase
    )
    $Counts = @{}
    # first separate by whitespace
    #   (consider underscore _ as whitepace too)
    $Phrase.ToLower() -split "[_\s]+" | ForEach-Object {
        # in separated tokens, elminate balanced single-quotes,
        #   then separate by any other characters that are NOT
        #   a single-quote or a letter or a numeral
        $_.Trim("'") -split "[^'\w]" | ForEach-Object {
            # ignore empty substrings, count everything else
            if ($_ -ne "") {
                $Counts[$_]++
            }
        }
    }
    return $Counts

    <#
    .SYNOPSIS
    Given a phrase, count how many time each word appear.

    .DESCRIPTION
    Count how many time each word appear in a phrase. Number in string also counted as word, and words are case insensitive.

    .PARAMETER Phrase
    The phrase to count words.

    .EXAMPLE
    Get-WordCount -Phrase "Hello, welcome to exercism!"
    Return: @{ hello = 1; welcome = 1; to = 1; exercism = 1}
    #>
}

