Function Invoke-MicroBlog() {
    [CmdletBinding()]
    Param(
        [string]$Post
    )
    $Iterator = [System.Globalization.StringInfo]::GetTextElementEnumerator($Post)
	$GraphemeClusterArray = [string[]]@()
    $Counter=0
    while ($Iterator.MoveNext() -and $Counter -lt 5) {
        $GraphemeClusterArray += $Iterator.GetTextElement()
        $Counter++
    }
    Return (-join $GraphemeClusterArray)

    <#
    .SYNOPSIS
    Implement a function to make micro blog post that only of 5 or less characters.

    .DESCRIPTION
    Given a string, truncate it into a string of maximum 5 characters.

    .PARAMETER Post
    A string object contains Unicode text encoding: alphabets, symbols or even emojis.

    .EXAMPLE
    Invoke-MicroBlog -Post "Lightning"
    Returns: "Light"
    #>
}