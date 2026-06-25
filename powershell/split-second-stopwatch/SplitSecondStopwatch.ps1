Enum States {
    Ready
    Running
    Stopped
}

class SplitSecondStopwatch {
    [States]$State = [States]::Ready
    [Timespan]$Total = [TimeSpan]::Zero
    [Timespan[]]$PreviousLaps = @()
    [ClockWrapper]$Clock
    [DateTime]$Reference

    SplitSecondStopWatch([ClockWrapper]$CW) {
        $this.Clock = $CW
        $this.Reference = $CW.Now
    }

    [Timespan] GetCurrentLap() {
        $CurrentLap = $this.Total
        if ($this.State -eq [States]::Running) {
            $CurrentLap += $this.Clock.Now - $this.Reference
        }
        return $CurrentLap
    }

    [Timespan] GetTotal() {
        $Acc = $this.GetCurrentLap()
        foreach ($T in $this.PreviousLaps) {
            $Acc += $T
        }
        return $Acc
    }

    [void] Start() {
        if ($this.State -eq [States]::Running) {
            throw "Invalid operation"
        }
        $this.State = [States]::Running
        $this.Reference = $this.Clock.Now
    }

    [void] Stop() {
        if ($this.State -ne [States]::Running) {
            throw "Invalid operation"
        }
        $this.Total += $this.Clock.Now - $this.Reference
        $this.Reference = $this.Clock.Now
        $this.State = [States]::Stopped
    }

    [void] Lap() {
        if ($this.State -ne [States]::Running) {
            throw "Invalid operation"
        }
        $this.Total += $this.Clock.Now - $this.Reference
        $this.PreviousLaps += , $this.Total
        $this.Reference = $this.Clock.Now
        $this.Total = [Timespan]::Zero
    }

    [void] Reset() {
        if ($this.State -ne [States]::Stopped) {
            throw "Invalid operation"
        }
        $this.PreviousLaps = @()
        $this.Total = [Timespan]::Zero
        $this.State = [States]::Ready
    }
}

class ClockWrapper {
    <#
    This class act as a simple timeprovider for the stopwatch
    DO NOT DELETE THIS CLASS
    #>
    [datetime]$Now
    ClockWrapper() {
        $this.Now = [datetime]::new(0)
    }

    [void] Advance([string]$span) {
        $this.Now += [TimeSpan]::Parse($span)
    }
}

<#
.SYNOPSIS
Build a stopwatch to keep precise track of lap times
.DESCRIPTION
Implement a stopwatch with these four commands (start, stop, lap, and reset) to keep track of:
    1. The current lap's tracked time
    2. Previously recorded lap times
The stopwatch also should able to report infomation about : current lap, total time and time of previous laps.

.NOTES
Input and comparison in test suite using string in the format of "HH:MM:SS" for ease of reading.
However implementation should use Timespan as suggested.
#>
