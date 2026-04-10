Function Invoke-Append() {
    [CmdletBinding()]
    Param(
        [object[]]$List1,
        [object[]]$List2
    )
    $Result = @()
    $List1 | ForEach-Object { $Result += , $_ }
    $List2 | ForEach-Object { $Result += , $_ }
    $Result
}

Function Invoke-Concatenate() {
    [CmdletBinding()]
    Param(
        [object[]]$Lists
    )
    $Result = @()
    $Lists | ForEach-Object { $Result = Invoke-Append -List1 $Result -List2 $_ }
    $Result
}

Function Invoke-Filter() {
    [CmdletBinding()]
    Param(
        [object[]]$List,
        [scriptblock]$Predicate
    )
    $Result = @()
    $List | ForEach-Object {
        $Candidate = $_
        if ( & $Predicate $Candidate ) {
            $Result += , $Candidate
        }
    }
    $Result

    # another way to do it:
    #   $List | Where-Object { & $Predicate $_ }
    # but could this be susceptible to Write-Output unwrapping?
}

Function Get-Length() {
    [CmdletBinding()]
    Param(
        [object[]]$List
    )
    $Result = 0
    $List | ForEach-Object { $Result++ }
    $Result
}

Function Invoke-Map() {
    [CmdletBinding()]
    Param(
        [object[]]$List,
        [scriptblock]$Function
    )
    $Result = @()
    $List | ForEach-Object {
        $Result += & $Function $_
    }
    $Result
}

Function Invoke-Foldl() {
    [CmdletBinding()]
    Param(
        [scriptblock]$Function,
        [object[]]$List,
        [object]$Accumulator
    )
    $Result = $Accumulator
    $List | ForEach-Object {
        $Result = & $Function $Result $_
    }
    $Result
}

Function Invoke-Reverse() {
    [CmdletBinding()]
    Param(
        [object[]]$List
    )
    $Result = @()
    $List | ForEach-Object {
        $Result = , $_ + $Result
    }
    $Result
}

Function Invoke-Foldr() {
    [CmdletBinding()]
    Param(
        [scriptblock]$Function,
        [object[]]$List,
        [object]$Accumulator
    )
    $Result = $Accumulator
    Invoke-Reverse $List | ForEach-Object {
        $Result = & $Function $Result $_
    }
    $Result
}

<#
.SYNOPSIS
Implement basic list operations.

.DESCRIPTION
Implement a series of basic list operations, without using existing functions:
- `append` (*given two lists, add all items in the second list to the end of the first list*);
- `concatenate` (*given a series of lists, combine all items in all lists into one flattened list*);
- `filter` (*given a predicate and a list, return the list of all items for which `predicate(item)` is True*);
- `length` (*given a list, return the total number of items within it*);
- `map` (*given a function and a list, return the list of the results of applying `function(item)` on all items*);
- `foldl` (*given a function, a list, and initial accumulator, fold (reduce) each item into the accumulator from the left*);
- `foldr` (*given a function, a list, and an initial accumulator, fold (reduce) each item into the accumulator from the right*);
- `reverse` (*given a list, return a list with all the original items, but in reversed order*).

Note, the ordering in which arguments are passed to the fold functions (`foldl`, `foldr`) is significant.

.EXAMPLE
Invoke-Append -List1 @(1, 3) -List2 @(2, 4)
Returns: @(1, 3, 2, 4)

Invoke-Reverse -List @(1, 2, 3, 4, 5)
Returns: @(5, 4, 3, 2, 1)
#>
