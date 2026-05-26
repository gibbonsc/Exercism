<#
.DESCRIPTION
    A helper class act as a data structure for the saddle point.
    It has a two properties: Row and Column, their indexes should be offset by 1 to reflect normal counting.
    It also has an Equals method for comparison in tests.
    Please don't delete or change this class.
#>
Class SaddlePoint {
    [int]$Row
    [int]$Column

    SaddlePoint($row, $col) {
        $this.Row = $row
        $this.Column = $col
    }

    [bool] Equals($other) {
        return $this.Row -eq $other.Row -and $this.Column -eq $other.Column
    }
}

Function Get-SaddlePoints() {
    [CmdletBinding()]
    Param(
        [int[][]]$Matrix
    )

    $RowCount = $Matrix.Count
    if (0 -eq $RowCount) { return $null }
    $ColCount = $Matrix[0].Count
    for ($r = 1; $r -lt $RowCount; $r++) {
        if ($Matrix[$r].Count -ne $ColCount) {
            throw "Irregular Matrix"
        }
    }

    # find row maxima
    $MaxValuesPerRow = $Matrix | ForEach-Object {
        ($_ | Measure-Object -Maximum).Maximum
    }
    Write-Debug "MaxValuesPerRow: $($MaxValuesPerRow -join ',')"

    # convert to .NET 2-D matrix object
    $TwoDMatrix = [int[, ]]::new($RowCount, $ColCount)
    for ($r = 0; $r -lt $RowCount; $r++) {
        for ($c = 0; $c -lt $ColCount; $c++) {
            $TwoDMatrix[$r, $c] = $Matrix[$r][$c]
        }
    }

    # find column minima
    $MinValuesPerCol = @()
    for ($c = 0; $c -lt $ColCount; $c++) {
        $ColValues = @()
        for ($r = 0; $r -lt $RowCount; $r++) {
            $Value = $TwoDMatrix[$r, $c]
            $ColValues += , $Value
        }
        $MinValuesPerCol += ($ColValues | Measure-Object -Minimum).Minimum
    }
    Write-Debug "MinValuesPerCol: $($MinValuesPerCol -join ',')"

    # search for saddle points
    [SaddlePoint[]]$Result = @()
    for ($r = 0; $r -lt $RowCount; $r++) {
        for ($c = 0; $c -lt $ColCount; $c++) {
            if ($MaxValuesPerRow[$r] -eq $MinValuesPerCol[$c]) {
                $Result += , [SaddlePoint]::new($r+1, $c+1)
            }
        }
    }
    return $Result

    <#
    .SYNOPSIS
    Find all the available saddle points in a given matrix.

    .DESCRIPTION
    Given a matrix (jagged arrays), return all the available saddle points found.
    The matrix can have a different number of rows and columns (non square), and it may have zero or more saddle points.

    It's called a "saddle point" because it is greater than or equal to every element in its row and less than or equal to every element in its column.

    Your code should be able to provide the (possibly empty) list of all the saddle points for any given matrix.

    .PARAMETER Matrix
    An array of arrays, each inner array contains number that could be a saddle point.

    .EXAMPLE
    Get-SaddlePoints -Matrix @( ,@(1, 2, 3))
    Returns: [SaddlePoint]::new(1, 3)
    #>
}
