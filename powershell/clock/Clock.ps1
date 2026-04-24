Function HandString {
<#
.SYNOPSIS
    helper function for Clock's ToString() method
#>
    param([int]$Hand)

    $HandString = "$Hand"
    if ($Hand -lt 10) {
        $HandString = "0" + $Handstring
    }
    return $Handstring
}

class Clock {
    [uint] $HourHand
    [uint] $MinuteHand

    hidden [void] InitClockFromMinutes([int]$Minutes) {
        if ($Minutes -lt 0) {
            # roll negative minutes up to positive day minute mark
            $Minutes = (24*60) - (-$Minutes % (24*60))
        }
        $this.MinuteHand = ($Minutes % 60)
        $this.HourHand = ($Minutes - $this.MinuteHand) / 60 % 24
    }

    Clock([int]$H,[int]$M) {
        $TotalMinutes = $H * 60 + $M
        $this.InitClockFromMinutes($TotalMinutes)
    }

    [string] ToString() {
        return (HandString $this.HourHand) + ":" +
            (HandString $this.MinuteHand)
    }

    [Clock] Add([int]$M) {
        $NewMinutes = $this.HourHand * 60 + $this.MinuteHand + $M
        $Result = [Clock]::New(0, $NewMinutes)
        return $Result
    }

    [bool] Equals([Object]$C) {
        if ($C.GetType().Name -ne "Clock") { return $false }
        return $this.HourHand -eq $C.HourHand -and
            $this.MinuteHand -eq $C.MinuteHand
    }
}

<#
.SYNOPSIS
    Implement a clock that handles times without dates.

.DESCRIPTION
    Implement a clock that handles times without dates in 24 hours format.
    You should be able to add and subtract minutes to it.
    Two clocks that represent the same time should be equal to each other.
    Note: Please try to implement the class and its method instead of using built-in module Datetime.

.EXAMPLE
    $clock1 = [Clock]::new(5,0)
    $clock1.ToString()
    Return: "05:00"

    $clock2 = [Clock]::new(6,-120)
    $clock2.Add(60).ToString()
    Return: "05:00"

    $clock1 -eq $clock2
    Return: $true
#>
