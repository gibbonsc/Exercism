Class BowlingGame {
    [int] $CurrentFrame
    [int] $Standing
    [bool] $FirstRoll
    [hashtable[]] $Frames

    BowlingGame() {
        # ten frames indexed 0 through 9
        $this.CurrentFrame = 0
        # how many pins are standing?
        $this.Standing = 10
        # is this the frame's first roll?
        $this.FirstRoll = $true
        # list of hashtables with previous rolls' scores
        $this.Frames = @()
    }

    hidden AdvanceFrame() {
        $this.CurrentFrame++
        $this.Standing = 10
        $this.FirstRoll = $true
    }

    Roll($pins) {
        if ($pins -lt 0 -or 10 -lt $pins) {
            throw "$pins pins cannot fall in one roll"
        }
        if ($pins -gt $this.Standing) {
            throw "Can't score $pins with only " +
                "$($this.Standing) pins standing"
        }
        if ($this.CurrentFrame -lt 9) {
            if ($this.FirstRoll) {
                $this.Frames += , @{First = $pins; Second = $null}
                if ($pins -lt 10) {
                    # prepare for second roll
                    $this.Standing -= $pins
                    $this.FirstRoll = $false
                }
                else {
                    # strike; no second roll this frame
                    $this.AdvanceFrame()
                }
            }
            else {
                # second roll
                $this.Frames[$this.CurrentFrame]["Second"] = $pins
                $this.AdvanceFrame()
            }
        }
        elseif ($this.CurrentFrame -eq 9) {
            # last frame
            if ($this.FirstRoll) {
                $this.FirstRoll = $false
                $this.Frames += @{First = $pins}
                # For a final frame strike,
                # just leave all ten pins standing for bonus rolls.
                # But if the final first roll is not a strike...
                if ($pins -lt 10) {
                    # ready for second roll
                    $this.Standing -= $pins
                }
            }
            elseif (-not $this.Frames[9].ContainsKey("Second")) {
                # second roll
                $this.Frames[9]["Second"] = $pins
                $this.Standing -= $pins
                if (
                    $this.Frames[9]["First"] -lt 10 -and
                    $this.Standing -gt 0
                ) {
                    # open final frame
                    $this.AdvanceFrame()
                }
                elseif (
                    $this.Frames[9]["First"] -lt 10 -and
                    $this.Standing -eq 0
                ) {
                    # spare final frame
                    $this.Standing = 10
                }
                else {
                    # final frame first roll was strike
                    if ($pins -eq 10) {
                        # second roll (first bonus) is also strike
                        $this.Standing = 10
                    }
                }
            }
            else {
                # strike or spare in final frame provides third roll
                $this.Frames[9]["Third"] = $pins
                $this.AdvanceFrame()
            }
        }
        else {
            throw "Game Over"
        }
    }

    [int] Score() {
        if ($this.CurrentFrame -lt 10) {
            throw "Can't score, game still in progress"
        }
        $Result, $i = 0, 0
        for ($f = 0; $f -lt 10; $f++) {
            # strike?
            $FirstScore = $this.Frames[$f]["First"]
            if ($FirstScore -eq 10) {
                $NextScore1 = $NextScore2 = 0
                if ($f -lt 8) {
                    # for first eight frames, add two subsequent roll scores
                    $NextScore1 = $this.Frames[$f+1]["First"]
                    $NextScore2 = $this.Frames[$f+1]["Second"]
                    if ($NextScore1 -eq 10) {
                        # if first subsequent roll score is also a strike,
                        # second subsequent roll comes from yet another frame
                        $NextScore2 = $this.Frames[$f+2]["First"]
                    }
                }
                elseif ($f -eq 8) {
                    # ninth frame: both subsequent rolls come from tenth
                    $NextScore1 = $this.Frames[$f+1]["First"]
                    $NextScore2 = $this.Frames[$f+1]["Second"]
                }
                else {
                    # tenth frame: both subsequent rolls come from tenth
                    $NextScore1 = $this.Frames[9]["Second"]
                    $NextScore2 = $this.Frames[9]["Third"]
                }
                $Result += 10 + $NextScore1 + $NextScore2
            }
            # spare?
            elseif ($FirstScore + $this.Frames[$f]["Second"] -eq 10) {
                $NextScore = 0
                if ($f -le 8) {
                    # for first nine frames, add one subsequent roll score
                    $NextScore = $this.Frames[$f+1]["First"]
                }
                else {
                    # tenth frame holds its own subsequent (third) roll score
                    $NextScore = $this.Frames[9]["Third"]
                }
                $Result += 10 + $NextScore
            }
            else {
                # open frame
                $Result += $FirstScore + $this.Frames[$f]["Second"]
            }
        }
        return $Result
    }
}
<#
.SYNOPSIS
    Implement a class to score a bowling game.

.DESCRIPTION
    For the detailed rules of the game, check instructions.

    Write code to keep track of the score of a game of bowling.
    It should support two operations:

    - roll(pins): is called each time the player rolls a ball.
    The argument is an integer represent the number of pins got knocked down (0 - 10)

    - score(): is called only at the very end of the game.
    It returns an integer represent the total score for that game.

    The class also should handle various cases of errors based on invalid or illegal inputs.
    You can decide what error message you want to throw.

.EXAMPLE
    $rolls = @(10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10)
    $game = [BowlingGame]::new()

    foreach ($roll in $rolls) {
        $game.Roll($roll)
    }
    $game.Score()
    Returns: 300
#>
