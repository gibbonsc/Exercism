Function Get-ReverseString {
    [CmdletBinding()]
    Param(
        [Parameter(Position=1, ValueFromPipeline=$true)]
        [string]$Forward
	)
    # optional harder tests: handle Unicode grapheme clusters
    $Iterator = [System.Globalization.StringInfo]::GetTextElementEnumerator($Forward)
	$GraphemeClusterArray = [string[]]@()
    while ($Iterator.MoveNext()) {
        $GraphemeClusterArray += $Iterator.GetTextElement()
    }
    [Array]::Reverse($GraphemeClusterArray)
    Return (-join $GraphemeClusterArray)

    <#
    .SYNOPSIS
    Reverse a string

    .DESCRIPTION
    Reverses the string in its entirety. That is it does not reverse each word in a string individually.

    .PARAMETER Forward
    The string to be reversed

    .EXAMPLE
    Get-ReverseString "PowerShell"
    
    This will return llehSrewoP

    .EXAMPLE
    Get-ReverseString "racecar"

    This will return racecar as it is a palindrome
    #>
}
