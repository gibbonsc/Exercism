Enum Sublist { UNEQUAL; SUBLIST; SUPERLIST; EQUAL }
Function Test-NonEmptySubArray {
    # utility function for Invoke-Sublist
    [CmdletBinding()] Param ([object[]]$ShorterArray, [object[]]$LargerArray)
    $SCount = $ShorterArray.Count
    $LCount = $LargerArray.Count
    $Found = $false
    $Index = 0  # start comparing at the beginning of the larger array
    while (-not $Found) {
        $Found = $true
        for ($i = 0; $i -lt $SCount; $i++) {
            if ($ShorterArray[$i] -ne $LargerArray[$i + $Index]) { $Found = $false; break }
        }
        if ($Found) { return $true }
        $Index++
        if ($Index -gt $LCount - $SCount) { break }
    }
    return $false
}
Function Invoke-Sublist() {
    [CmdletBinding()]
    Param (
        [object[]]$Data1,
        [object[]]$Data2
    )
    $Data1Count = $Data1.Count
    $Data2Count = $Data2.Count
    if ($Data1Count -eq $Data2Count) {
        if ($Data1Count -eq 0) { return [Sublist]::EQUAL }
        else {  # nonempty arrays, so test for memberwise equality
            for ($i = 0; $i -lt $Data1Count; $i++) {
                if ($Data1[$i] -ne $Data2[$i]) { return [Sublist]::UNEQUAL }
            }
            return [Sublist]::EQUAL
        }
    }
    elseif ($Data1Count -eq 0) { return [Sublist]::SUBLIST }
    elseif ($Data2Count -eq 0) { return [Sublist]::SUPERLIST }
    # nonempty arrays of different sizes, so 
    elseif ($Data1Count -lt $Data2Count) {
        return (Test-NonEmptySubArray $Data1 $Data2) ? [Sublist]::SUBLIST : [Sublist]::UNEQUAL
    }
    else {
        return (Test-NonEmptySubArray $Data2 $Data1) ? [Sublist]::SUPERLIST : [Sublist]::UNEQUAL
    }
    throw "Unable to determine sublist relationship"
    <#
    .SYNOPSIS
    Determine the relationship of two arrays.

    .DESCRIPTION
    Given two arrays, determine the relationship of the first array relating to the second array.
    There are four possible categories: EQUAL, UNEQUAL, SUBLIST and SUPERLIST.
    Note: This exercise use Enum values for return.
    
    .PARAMETER Data1
    The first array

    .PARAMETER Data2
    The second array

    .EXAMPLE
    Invoke-Sublist -Data1 @(1,2,3) -Data2 @(1,2,3)
    Return: [Sublist]::EQUAL

    Invoke-Sublist -Data1 @(1,2) -Data2 @(1,2,3)
    Return: [Sublist]::SUBLIST
    #>
}