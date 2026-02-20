Function Get-Slices() {
    [CmdletBinding()]
    Param(
        [string]$Series,
        [int]$SliceLength
    )

    $SeriesLength = $Series.Length
    if ($SeriesLength -eq 0) {
        throw "Series cannot be empty."
    }
    elseif ($SliceLength -gt $SeriesLength) {
        throw "Slice length cannot be greater than series length."
    }
    elseif ($SliceLength -lt 0) {
        throw "Slice length cannot be negative."
    }
    elseif ($SliceLength -eq 0) {
        throw "Slice length cannot be zero."
    }
    $Result = @()
    0 .. ($SeriesLength - $SliceLength) | ForEach-Object {
        $Result += , $Series.Substring($_, $SliceLength)
    }
    Return $Result
    <#
    .SYNOPSIS
    Given a string of digits, output all the contiguous substrings of length `n` in that string.
    
    .DESCRIPTION
    The function takes a string of digits and returns all the contiguous substrings of length `n` in that string.

    .PARAMETER Series
    The string of digits

    .PARAMETER SliceLength
    The length of the slices to return
    
    .EXAMPLE
    Get-Slices -Series "01234" -SliceLength 2
    
    Returns: @("01", "12", "23", "34")
    #>
}
