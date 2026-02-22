Function Get-Acronym() {
    [CmdletBinding()]
    Param (
        [string]$Phrase
    )
    $Words = $Phrase.ToUpper() -split '[ -]'
    -join ($Words | ForEach-Object { ($_ -replace '[_\W]')[0] })
    <#
    .SYNOPSIS
    Get the acronym of a phrase.

    .DESCRIPTION
    Given a phrase, return the string acronym of that phrase.
    "As Soon As Possible" => "ASAP"
    
    .PARAMETER Phrase
    The phrase to get the acronym from.
    
    .EXAMPLE
    Get-Acronym -Phrase "As Soon As Possible"
    #>
}