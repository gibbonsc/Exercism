Function Invoke-BinarySearch() {
    [CmdletBinding()]
    Param(
        [Int64[]]$Array,
        [Int64]$Value
    )

    $LowerIndex,$UpperIndex = 0,($Array.Count - 1)
    while ($LowerIndex -lt $UpperIndex) {
        $MiddleIndex = [int](($UpperIndex+$LowerIndex)/2)
        if ($Array[$MiddleIndex] -lt $Value) {
            $LowerIndex = $MiddleIndex + 1
        }
        elseif ($Array[$MiddleIndex] -gt $Value) {
            $UpperIndex = $MiddleIndex - 1
        }
        else {  # found; $Array[$MiddleIndex] is equal to $Value
            return $MiddleIndex
        }
    }
    if ($Array[$LowerIndex] -ne $Value) {
        Throw "error: value not in array"    
    }
    Return $LowerIndex
    <#
    .SYNOPSIS
    Perform a binary search on a sorted array.

    .DESCRIPTION
    Take an array of integers and a search value and return the index of the value in the array.

    .PARAMETER Array
    The array to search.

    .PARAMETER Value
    The value to search for.

    .EXAMPLE
    Invoke-BinarySearch -Array @(1, 2, 3, 4, 5) -Value 3
    #>
}
