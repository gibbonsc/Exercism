$Script:ColorCode = [ordered]@{
    "black"=0
    "brown"=1
    "red"=2
    "orange"=3
    "yellow"=4
    "green"=5
    "blue"=6
    "violet"=7
    "grey"=8
    "gray"=8
    "white"=9
}

Function Get-ColorCode() {
    [CmdletBinding()]
    Param(
        [string]$Color
    )
    Return $Script:ColorCode[$Color]
    <#
    .SYNOPSIS
    Translate a color to its corresponding color code.

    .DESCRIPTION
    Given a color, return its corresponding color code.

    .PARAMETER Color
    The color to translate to its corresponding color code.

    .EXAMPLE
    Get-ColorCode -Color "black"
    #>
}

Function Get-Colors() {
    Return ( $script:ColorCode.keys | Where-Object {$_ -ne "gray"} )
    <#
    .SYNOPSIS
    Return the list of all colors.

    .DESCRIPTION
    Return the list of all colors.

    .EXAMPLE
    Get-Colors
    #>
}
