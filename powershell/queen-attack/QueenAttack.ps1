Class ChessBoard {
    [int[]]$White
    [int[]]$Black

    ChessBoard() {
        $this.White, $this.Black  = @(7, 3), @(0, 3)
    }
    ChessBoard([int[]]$W,[int[]]$B) {
        if (
            $W[0] -lt 0 -or 8 -le $W[0] -or
            $W[1] -lt 0 -or 8 -le $W[1]
        ) {
            throw "White queen must be placed on the board"
        }
        if (
            $B[0] -lt 0 -or 8 -le $B[0] -or
            $B[1] -lt 0 -or 8 -le $B[1]
        ) {
            throw "Black queen must be placed on the board"
        }
        if ($B[0] -eq $W[0] -and $B[1] -eq $W[1]) {
            throw "Queens can not share the same space"
        }
        ($this.White), ($this.Black) = $W, $B
    }

    [bool] CanAttack() {
        $RowDelta = ($this.White[0] -ge $this.Black[0]) ?
            ($this.White[0] - $this.Black[0]) :
            ($this.Black[0] - $this.White[0])
        $FileDelta = $this.White[1] -ge $this.Black[1] ?
            ($this.White[1] - $this.Black[1]) :
            ($this.Black[1] - $this.White[1])
        if (
            $RowDelta -eq 0 -or
            $FileDelta -eq 0 -or
            $RowDelta -eq $FileDelta
        ) {
            return $true
        }
        return $false
    }
    [string[]] DrawBoard() {
        $U = [char]'_'
        $Surface = 1..8 | ForEach-Object -Begin {
            $S = @()
        } -Process {
            $S += @(
                , @(
                1..8 | ForEach-Object {
                    @('_')
                }
                )
            )
        } -End {
            $S
        }
        $Surface[$this.White[0]][$this.White[1]] = 'W'
        $Surface[$this.Black[0]][$this.Black[1]] = 'B'
        return ($Surface | ForEach-Object { $_ -join ' ' }) -join "`r`n"
    }
}

<#
.SYNOPSIS
    Given the positions of two queens on a chess board,
    indicate whether or not they are positioned so that they can attack each other.

.DESCRIPTION
    In a chessboard represented by an 8 by 8 array, check if a queen can attack another queen based on their positions.
    In the game of chess, a queen can attack pieces which are on the same row, column, or diagonal.
    If there are no position provided, queens will be placed at their starting positions: White at bottom (7,3), Black at top (0,3).

.EXAMPLE
    #Positions provided:
    $whitePosition = @(2, 2)
    $blackPosition = @(5, 6)
    $board = [ChessBoard]::new($whitePosition, $blackPosition)
    $board.CanAttack() => False
    $board.DrawBoard()
    @"
    _ _ _ _ _ _ _ _
    _ _ _ _ _ _ _ _
    _ _ W _ _ _ _ _
    _ _ _ _ _ _ _ _
    _ _ _ _ _ _ _ _
    _ _ _ _ _ _ B _
    _ _ _ _ _ _ _ _
    _ _ _ _ _ _ _ _
    "@

    #No positions provided:
    $board2 = [ChessBoard]::new()
    $board2.CanAttack() => True
    $board.DrawBoard()
    @"
    _ _ _ B _ _ _ _
    _ _ _ _ _ _ _ _
    _ _ _ _ _ _ _ _
    _ _ _ _ _ _ _ _
    _ _ _ _ _ _ _ _
    _ _ _ _ _ _ _ _
    _ _ _ _ _ _ _ _
    _ _ _ W _ _ _ _
    "@
#>
