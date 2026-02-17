Function Get-SpaceAge() {
    [CmdletBinding()]
    Param(
        [int]$Seconds,
        # [ValidateSet(
        #     "Mercury","Venus","Earth","Mars",
        #     "Jupiter","Saturn","Uranus","Neptune")]
        [string]$Planet = "Earth"
    )

    $Ratios = @{
        Mercury=0.2408467; Venus=0.61519726; Earth=1.0; Mars=1.8808158;
        Jupiter=11.862615; Saturn=29.447498; Uranus=84.016846; Neptune=164.79132
    }
    if ($Ratios.Keys -notcontains $Planet) {
        Throw "Invalid planet"
    }
    $Years = $Seconds / 60.0 / 60.0 / 24.0 / 365.25
    $Result = [int]($Years * 100.0 / $Ratios["$Planet"])
    $Result /= 100.0
    Return $Result
    <#
    .SYNOPSIS
    Given an age in seconds, calculate how old someone would be on a planet in the solar system. (RIP Pluto)
    
    .DESCRIPTION
    The function takes a positive integer, and return a double (float) to show how old someone is on a specific planet.

    .PARAMETER $Seconds
    The seconds of a person's age.

    .PARAMETER $Planet
    The planet to calculate how old the person would be on it.
    Note: Since the planets in the solar system is a known shortlist, we can just validate the input with a set of values in the params.
    If no planet is specified, it should be default to Earth.
    
    .EXAMPLE
    Get-SpaceAge -Seconds 1000000000 -Planet Neptune
    Retuns: 0.19
    #>
}