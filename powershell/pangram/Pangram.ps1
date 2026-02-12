Function Invoke-Panagram() {
    [CmdletBinding()]
    Param(
        [string]$Sentence
    )

    $Shout = $Sentence.ToLower()
    foreach ($c in 'a'..'z') {
        if ($Shout.IndexOf($c) -lt 0) {
            return $false
        }
    }
    return $true

    <#
    .SYNOPSIS
    Determine if a sentence is a pangram.
    
    .DESCRIPTION
    A pangram is a sentence using every letter of the alphabet at least once.
    
    .PARAMETER Sentence
    The sentence to check
    
    .EXAMPLE
    Invoke-Panagram -Sentence "The quick brown fox jumps over the lazy dog"
    
    Returns: $true
    #>
}
