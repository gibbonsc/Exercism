Class WordSearch {
    [string[]] $Grid
    [int] $Width
    [int] $Height

    WordSearch([string[]]$grid) {
        $this.Grid = $grid
        $this.Height = $grid.Count
        $this.Width = $grid[0].Length
    }

    [pscustomobject] Search ($word) {
        # directional grid offsets (row-major)
        [int[][]]$Compass = @(  # directional grid offsets (row-major)
            @(0, 1),  # E
            @(1, 1),  # SE
            @(1, 0),  # S
            @(1, -1),  # SW
            @(0, -1),  # W
            @(-1, -1),  # NW
            @(-1, 0),  # N
            @(-1, 1)  # NE
        )
        $WordLength = $word.Length
        for ($r = 0; $r -lt $this.Height; $r++) {
            for ($c = 0; $c -lt $this.Width; $c++) {
                foreach ($d in $Compass) {
                    $EndR = ($r + $d[0] * ($WordLength-1))
                    $EndC = ($c + $d[1] * ($WordLength-1))
                    if (
                        (0 -gt $EndR) -or
                        (0 -gt $EndC) -or
                        ($this.Height -le $EndR) -or
                        ($this.Width -le $EndC)
                    ) { continue }
                    $A = ""
                    for ($i = 0; $i -lt $WordLength; $i++) {
                        $A += $this.Grid[$r + $d[0] * $i].SubString(
                            $c + $d[1] * $i, 1)
                    }
                    if ($A -eq $word) {
                        $Result = [pscustomobject]::new()
                        $Result |
                            Add-Member -MemberType NoteProperty -Name 'Start' -Value @($r, $c)
                        $Result |
                            Add-Member -MemberType NoteProperty -Name 'End' -Value @($EndR, $EndC)
                        return $Result
                    }
                }
            }
        }
        return $null
    }
}

<#
.SYNOPSIS
    Implement a program to find word in a search puzzle.

.DESCRIPTION
    Given a grid of letters, find the target word that hides inside it.
    Words can be hidden in all kinds of directions: left-to-right, right-to-left, vertical and diagonal.

    Implement a class that will take in an array of string(s) represent the grid.
    Inside the class, implement a Search method that will take in a string as the target word.
    If found, return the result in an object that contain the location of the first and last letter.
    If the word doesn't exist in the grid, return $null.

    The object return must have these properties and their value in this format:
    - Start: @(row value, column value)
    - End  : @(row value, column value)
    Value of row and column follow the standard of 0-based index.

.EXAMPLE
    $grid = @(
        "jefblpepre",
        "camdcimgtc",
        "oivokprjsm",
        "pbwasqroua",
        "rixilelhrs",
        "wolcqlirpc",
        "screeaumgr",
        "alxhpburyi",
        "jalaycalmp",
        "clojurermt"
    )
    $puzzle = [WordSearch]::new($grid)
    $puzzle.Search("clojure")

    Returns: [PsCustomObject]@{
        Start = @(9, 0)
        End   = @(9, 6)
    }
#>
