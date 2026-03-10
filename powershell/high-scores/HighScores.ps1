Class HighScores {
    [int[]] $HighScoreList

    HighScores([int[]]$list){
        $this.HighScoreList = $list
    }
    [int[]] GetScores() {
        return $this.HighScoreList
    }
    [int[]] GetLatest() {
        return $this.HighScoreList[-1]
    }
    [int] GetPersonalBest() {
        return ($this.HighScoreList | Measure-Object -Maximum).Maximum
    }
    [int[]] GetTopThree() {
        $Length = $this.HighScoreList.Count
        $Sorted = $this.HighScoreList | Sort-Object -Descending
        if ($Length -le 3) {
            return $Sorted
        }
        else {
            return $Sorted[0..2]
        }
    }
}

<#
.SYNOPSIS
    Manage a game player's High Score list.

.DESCRIPTION
    Your task is to build a high-score component of the classic Frogger game, one of the highest selling and most addictive games of all time, and a classic of the arcade era.
    Your task is to write methods that return the highest score from the list, the last added score and the three highest scores.

.EXAMPLE
    $roster = [HighScores]::new(@(30, 50, 40, 90, 80))
    $roster.GetTopThree()
    return : @(90, 80, 50)
#>
