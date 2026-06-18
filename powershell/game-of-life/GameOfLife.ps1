Function Invoke-GameOfLife() {
    [CmdletBinding()]
    Param(
        [int[][]] $Matrix
    )

    if (0 -eq $Matrix.Count) { return [int[][]]@() }

    Function Measure-Neighbors {
        param($Row, $Col)
        $A = 0
        if ($Row -gt 0) {
            if ($Col -gt 0) {
                if (1 -eq $Matrix[$Row - 1][$Col - 1]) { $A++ }
            }
            if (1 -eq $Matrix[$Row - 1][$Col]) { $A++ }
            if ($Col -lt $Matrix[0].Count - 1) {
                if (1 -eq $Matrix[$Row - 1][$Col + 1]) { $A++ }
            }
        }
        if ($Col -lt $Matrix[0].Count - 1) {
            if (1 -eq $Matrix[$Row][$Col + 1]) { $A++ }
        }
        if ($Row -lt $Matrix.Count - 1) {
            if ($Col -lt $Matrix[0].Count - 1) {
                if (1 -eq $Matrix[$Row + 1][$Col + 1]) { $A++ }
            }
            if (1 -eq $Matrix[$Row + 1][$Col]) { $A++ }
            if ($Col -gt 0) {
                if (1 -eq $Matrix[$Row + 1][$Col - 1]) { $A++ }
            }
        }
        if ($Col -gt 0) {
            if (1 -eq $Matrix[$Row][$Col - 1]) { $A++ }
        }
        return $A
    }

    # prepare new matrix
    $Result = [int[][]]::new($Matrix.Count)
    for ($Row = 0; $Row -lt $Result.Count; $Row++) {
        $Result[$Row] = [int[]]::new($Matrix[0].Count)
    }

    # determine living/dead in new matrix
    for ($Row = 0; $Row -lt $Matrix.Count; $Row++) {
        for ($Col = 0; $Col -lt $Matrix.Count; $Col++) {
            $N = Measure-Neighbors $Row $Col
            if (3 -eq $N) {
                $Result[$Row][$Col] = 1
            }
            elseif (2 -eq $N -and $Matrix[$Row][$Col] -eq 1) {
                $Result[$Row][$Col] = 1
            }
            else {
                $Result[$Row][$Col] = 0
            }
        }
    }
    return @($Result)

    # 
    <#
    .SYNOPSIS
    Compute the next generation of cells for Conway's Game of Life.

    .DESCRIPTION
    Given a matrix of integer acting as cells in Conway's Game of Life, compute the next generation.
    Each cell has two states : alive (1) or dead (0).
    Each cell have eight neighbors, and the following rules are applied to each cell:
    - Any live cell with two or three live neighbors lives on.
    - Any dead cell with exactly three live neighbors becomes a live cell.
    - All other cells die or stay dead.

    .PARAMETER Matrix
    A matrix represent the current state of the game.

    .EXAMPLE
    $matrix = @(
        @(1, 1),
        @(1, 0)
    )
    
    Invok-GameOfLife -Matrix $matrix
    Returns:
    @(
        @(1, 1),
        @(1, 1)
    )
    #Bottom right cell come alive and the other three cells stay alive follow the logic of the rules.
    #>
}
