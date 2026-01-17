Function Invoke-FlattenArray() {
    [CmdletBinding()]
    Param(
        [System.Object[]]$Array
    )
    $Array | ForEach-Object {
        if ($_ -is [Object[]]) { Invoke-FlattenArray $_ }
        elseif ($null -ne $_) { $_ }
    }

    # (Moved documentation block comment to the bottom, to ease browsing at Exercism.org)
    <#
        Exercism.org mentor "glaxxie" showed me the following excellent
        pipeline solution that uses both ForEach-Object and Where-Object.
        ForEach-Object maps and flattens the nested arrays.
        Where-Object filters away the $null objects.

        $Array | ForEach-Object {
            ($_ -is [Object[]]) ? (Invoke-FlattenArray $_) : $_
        } | Where-Object { $null -ne $_ }
    #>

    <#
    .SYNOPSIS
    Take a nested array and return a single flattened array with all values except null.

    .DESCRIPTION
    Given an array, flatten it and keep all values except null.

    .PARAMETER Array
    The nested array to be flattened.

    .EXAMPLE
    Invoke-FlattenArray -Array @(1, @(2, 3, $null, 4), @($null), 5)
    Return: @(1, 2, 3, 4, 5)
    #>
}
