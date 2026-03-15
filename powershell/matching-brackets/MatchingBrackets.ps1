Function Test-MatchingBrackets() {
    [CmdletBinding()]
    Param(
        [string]$Text
    )

    $Pile = @()
    foreach ($c in [char[]] $Text) {
        switch ($c) {
            { $_ -in [char]'(', [char]'[', [char]'{' } {
                $Pile = , $c + $Pile
            }
            { $_ -in [char]')' } {
                if ($Pile.Length -eq 0) { return $false }
                $Pop, $Pile = $Pile
                if ($Pop -ne [char]'(') { return $false }
            }
            { $_ -in [char]']' } {
                if ($Pile.Length -eq 0) { return $false }
                $Pop, $Pile = $Pile
                if ($Pop -ne [char]'[') { return $false }
            }
            { $_ -in [char]'}' } {
                if ($Pile.Length -eq 0) { return $false }
                $Pop, $Pile = $Pile
                if ($Pop -ne [char]'{') { return $false }
            }
        }
    }
    if ($Pile.Length -ne 0) {
        return $false
    }
    return $true

    <#
    .SYNOPSIS
    Determine if all brackets inside a string paired and nested correctly.
    
    .DESCRIPTION
    Given a string containing brackets `[]`, braces `{}`, parentheses `()`, or any combination thereof, verify that any and all pairs are matched and nested correctly.
    The string may also contain other characters, which for the purposes of this exercise should be ignored.
    
    .PARAMETER Text
    The string to be verified.
    
    .EXAMPLE
    Test-MatchingBrackets("[]") => True
    Test-MatchingBrackets("[)]") => False
    #>
}