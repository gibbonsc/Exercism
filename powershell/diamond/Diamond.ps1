Function Get-DiamondTier {
    Param(
        [char]$Letter,
        [int]$Extent,
        [int]$Stretch
    )
    $Outside = $Extent - $Stretch
    $Inside = 2 * $Stretch + 1
    return " " * $Outside + $Letter +
    " " * $Inside + $Letter +
    " " * $Outside + "`r`n"
}
Function Invoke-Diamond() {
    [CmdletBinding()]
    Param(
        [char]$Letter
    )

    $Cusp = [char]([string] $Letter).ToUpper()
    if ($Cusp -eq [char]'A') { return "A`n" }

    $Gamut = [int]($Cusp - [char]'A')
    $Apex = " " * $Gamut + "A" + " " * $Gamut--
    # apex tier
    $Result = $Apex + "`r`n"
    $i = 0
    while ($i -le $Gamut) {
        $Paint = [char]([int][char]'A' + $i + 1)
        # upper tiers
        $Result += Get-DiamondTier $Paint $Gamut $i
        $i++
    }
    while ($i -gt 1) {
        $i--
        $Paint = [char]([int][char]'A' + $i)
        # lower tiers
        $Result += Get-DiamondTier $Paint $Gamut ($i - 1)
    }
    $Result += $Apex
    return $Result

    <#
    .SYNOPSIS
    Given a letter, output a diamond shape.

    .DESCRIPTION
    Take a letter of the alphabet, return a string in a diamond shape starting with 'A', with the supplied letter at the widest point.
    The output should use only capitalized letters, however the input should be case-insensitive.

    .PARAMETER Letter
    The letter used to decide the shape of the diamond.

    .EXAMPLE
    Invoke-Diamond -Letter D
    Return:
    @"
       A   
      B B  
     C   C 
    D     D
     C   C 
      B B  
       A   
    "@ 
    #>
}