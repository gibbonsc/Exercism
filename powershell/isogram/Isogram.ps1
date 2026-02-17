Function Invoke-Isogram() {
    [CmdletBinding()]
    Param(
        [string]$Phrase
    )

    $AlphabeticProfile = @{}
    foreach ($C in [char[]]$Phrase) {
        if (($C -ge [char]'A' -and $C -le [char]'Z') -or
            ($C -ge [char]'a' -and -$C -le [char]'z')) {
            $AlphabeticProfile["$C"]++
            if ($AlphabeticProfile["$C"] -gt 1) {
                return $false  # found repeated letter
            }
        }
    }
    return $true  # didn't find any repeated letters
    <#
    .SYNOPSIS
    Determine if a word or phrase is an isogram.
    
    .DESCRIPTION
    An isogram (also known as a "nonpattern word") is a word or phrase without a repeating letter,
    however spaces and hyphens are allowed to appear multiple times.
    
    .PARAMETER Phrase
    The phrase to check if it is an isogram.
    
    .EXAMPLE
    Invoke-Isogram -Phrase "isogram"
    
    Returns: $true
    #>
}
