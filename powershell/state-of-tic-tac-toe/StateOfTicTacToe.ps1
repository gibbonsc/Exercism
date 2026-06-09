enum GameStatus {
    ONGOING
    DRAW
    WIN
}

Function Get-StateOfTicTacToe() {
    [CmdletBinding()]
    Param(
        [string[]]$Board
    )

    $XMoves = @()
    $OMoves = @()

    $XRowWin, $ORowWin = $false, $false
    for ($R = 0; $R -lt 3; $R++) {
        # easy to directly check for winning row
        if ("XXX" -eq $Board[$R]) {
            $XRowWin = $true
        }
        elseif ("OOO" -eq $Board[$R]) {
            $ORowWin = $true
        }

        # count moves
        for ($C = 0; $C -lt 3; $C++) {
            $Ch = $Board[$R].Substring($C,1)
            switch ($Ch) {
                "X" { $XMoves += , "$R,$C"; break }
                "O" { $OMoves += , "$R,$C"; break }
            }
        }
    }
    if ($XMoves.Count - $OMoves.Count -gt 1) {
        throw "Wrong turn order: X went twice"
    }
    if ($OMoves.Count - $XMoves.Count -gt 0) {
        throw "Wrong turn order: O started"
    }

    # check for winning columns
    $XColWin, $OColWin = $false, $false
    for ($C = 0; $C -lt 3; $C++) {
        if ("0,$C" -in $XMoves -and 
            "1,$C" -in $XMoves -and
            "2,$C" -in $XMoves) {
            $XColWin = $true
        }
        elseif ("0,$C" -in $OMoves -and
            "1,$C" -in $OMoves -and
            "2,$C" -in $OMoves) {
            $OColWin = $true
        }
    }

    # check for winning diagonal
    $XDiagWin, $ODiagWin = $false, $false
    if ("1,1" -in $XMoves -and
        (("0,0" -in $XMoves -and  "2,2" -in $XMoves) -or
        ("2,0" -in $XMoves -and "0,2" -in $XMoves))) {
            $XDiagWin = $true
    }
    elseif ("1,1" -in $OMoves -and
        (("0,0" -in $OMoves -and  "2,2" -in $OMoves) -or
        ("2,0" -in $OMoves -and "0,2" -in $OMoves))) {
            $ODiagWin = $true
    }

    # check whether moves must have occurred after a win
    if (($XRowWin -and $ORowWin) -or ($XColWin -and $OColWin)) {
        throw "Impossible board: game should have ended after the game was won"
    }

    # report game status
    if ($XRowWin -or $XColWin -or $XDiagWin -or
        $ORowWin -or $OColWin -or $ODiagWin) {
        return [GameStatus]::WIN
    }
    elseif ($XMoves.Count -eq 5 -and $OMoves.Count -eq 4) {
        return [GameStatus]::DRAW
    }
    return [GameStatus]::ONGOING

    <#
    .SYNOPSIS
    Implement a program that determines the state of a tic-tac-toe game.

    .DESCRIPTION
    The games is played on a 3×3 grid represent by an array of 3 strings.
    Players take turns to place `X`s and `O`s on the grid.
    The game ends:
    - when one player has won by placing three of marks in a row, column, or along a diagonal of the grid
    - when the entire grid is filled up

    In this exercise, we will assume that `X` always starts first.

    .PARAMETER Board
    An array of 3 strings represeting the board in the form of 3x3 grid.

    .EXAMPLE
    $board = @(
        "XOO",
        "X  ",
        "X  "
    )
    Get-StateOfTicTacToe -Board $board
    Returns: [GameStatus]::WIN
    #>
}
