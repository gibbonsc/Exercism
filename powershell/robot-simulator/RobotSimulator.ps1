Enum Direction {
    NORTH
    EAST
    SOUTH
    WEST
}

Class Robot {
    [Direction]$Direction
    [int]$PositionX
    [int]$PositionY

    Robot() {
        $this.Direction = [Direction]::NORTH
        $this.PositionX, $This.PositionY = 0, 0
    }
    Robot($d, $px, $py) {
        if ($null -eq $d) {throw "Error: Invalid direction" }
        if ($null -eq $px) {throw "Error: Invalid X position" }
        if ($null -eq $py) {throw "Error: Invalid Y position" }
        try { $this.Direction = [Direction]$d }
        catch { throw "Error: Invalid direction" }
        try { $this.PositionX = $px }
        catch { throw "Error: Invalid X position" }
        try { $this.PositionY = $py }
        catch { throw "Error: Invalid Y position" }
    }

    TurnLeft() {
        if ($this.Direction -eq [Direction]::NORTH) {
            $this.Direction = [Direction]::WEST
        }
        elseif ($this.Direction -eq [Direction]::EAST) {
            $this.Direction = [Direction]::NORTH
        }
        elseif ($this.Direction -eq [Direction]::SOUTH) {
            $this.Direction = [Direction]::EAST
        }
        elseif ($this.Direction -eq [Direction]::WEST) {
            $this.Direction = [Direction]::SOUTH
        }
    }
    TurnRight() {
        if ($this.Direction -eq [Direction]::NORTH) {
            $this.Direction = [Direction]::EAST
        }
        elseif ($this.Direction -eq [Direction]::EAST) {
            $this.Direction = [Direction]::SOUTH
        }
        elseif ($this.Direction -eq [Direction]::SOUTH) {
            $this.Direction = [Direction]::WEST
        }
        elseif ($this.Direction -eq [Direction]::WEST) {
            $this.Direction = [Direction]::NORTH
        }
    }
    Advance() {
        if ($this.Direction -eq [Direction]::NORTH) {
            ++$this.PositionY
        }
        elseif ($this.Direction -eq [Direction]::EAST) {
            ++$this.PositionX
        }
        elseif ($this.Direction -eq [Direction]::SOUTH) {
            --$this.PositionY
        }
        elseif ($this.Direction -eq [Direction]::WEST) {
            --$this.PositionX
        }
    }

    Move([string]$Instruction) {
        $Letters = [char[]]$Instruction
        foreach ($C in $Letters) {
            if ($C -eq [char]'L') { $this.TurnLeft() }
            elseif ($C -eq [char]'R') { $this.TurnRight() }
            elseif ($C -eq [char]'A') { $this.Advance() }
            else { throw "Error: Invalid instruction" }
        }
    }

    [int[]] GetPosition() {
        return @($this.PositionX, $this.PositionY)
    }
}

<#
.SYNOPSIS
    Write a robot simulator that take in instructions of how to move.
    
.DESCRIPTION
    A robot factory's test facility needs a program to verify robot movements.
    The robots have three possible movements:
    - turn right
    - turn left
    - advance

    Robots are placed on a hypothetical infinite grid, facing a particular direction (north, east, south, or west) at a set of {x,y} coordinates,
    e.g., {3,8}, with coordinates increasing to the north and east.

    A robot instance without any input should be at the default location : facing North at (0, 0)
    
.EXAMPLE
    $robot = [Robot]::new('NORTH', 7, 3)
    $robot.Move("RAALAL")

    $robot.Direction
    Returns: WEST

    $robot.GetPosition()
    Returns: @(9, 4)
#>
