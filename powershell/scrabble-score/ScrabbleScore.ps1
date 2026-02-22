Function Get-ScrabbleScore() {
    [CmdletBinding()]
    Param(
        [string]$Word,
        [switch]$Bonus
    )
    $Score = 0
    for ($i = 0; $i -lt $Word.Length; $i++) {
        $LetterScore =
        switch (([string]$Word[$i]).ToUpper()) {
            { $_ -in @('A', 'E', 'I', 'O', 'U', 'L', 'N', 'R', 'S', 'T') } { 1 }
            { $_ -in @('D', 'G') } { 2 }
            { $_ -in @('B', 'C', 'M', 'P') } { 3 }
            { $_ -in @('F', 'H', 'V', 'W', 'Y') } { 4 }
            { $_ -eq @('K') } { 5 }
            { $_ -in @('J', 'X') } { 8 }
            { $_ -in @('Q', 'Z') } { 10 }
            default: { 0 }
        }
        
        $Score += $LetterScore
    }
    return $Bonus ? ($Score * 2) : $Score
    <#
    .SYNOPSIS
    Given a word, compute the Scrabble score for that word.

    .DESCRIPTION
    Take a string and return an integer value as score based on the values of letters.
    If the word landed on a bonus, double the point for that word.

    Letter                           Value
    A, E, I, O, U, L, N, R, S, T       1
    D, G                               2
    B, C, M, P                         3
    F, H, V, W, Y                      4
    K                                  5
    J, X                               8
    Q, Z                               10

    .PARAMETER Word
    The string to calculate scrabble score.

    .PARAMETER Bonus
    A boolean value that activate the bonus point if present.

    .EXAMPLE
    Get-ScrabbleScore -Word "Hello"
    Return: 8
    #>
}