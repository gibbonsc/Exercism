Function Get-PrismSequence() {
    [CmdletBinding()]
    Param(
        [Laser]$Laser,
        [Prism[]]$Prisms
    )

    $TraceId = -1
    $Epsilon = 0.005  # tolerance for angle measurements

    Function Get-CollidingPrisms {
        $Prisms | Where-Object {
            [Math]::Abs(
                [Math]::Atan2(
                    $_.Y - $Laser.Y, $_.X - $Laser.X
                ) - $Laser.Angle
            ) -lt $Epsilon -and
            $TraceId -ne $_.Id
        } | Sort-Object {
            $XDelta = $_.X - $Laser.X
            $YDelta = $_.Y - $Laser.Y
            $XDelta * $XDelta + $YDelta * $YDelta
        }
    }

    $R = @()  # Initialize list of prism IDs to be returned
    $Hits = Get-CollidingPrisms
    while ($null -ne $Hits) {
        # append nearest colliding prism
        $TraceId = $Hits[0].Id
        $R += , $TraceId
        # update laser beam source position
        $Laser.X = $Hits[0].X
        $Laser.Y = $Hits[0].Y
        # update laser beam angle
        $Laser.Angle += $Hits[0].Angle
        # normalize laser beam angle to (-π, π] (within epsilon tolerance)
        if ($Laser.Angle -gt [Math]::PI + $Epsilon) {
            $Laser.Angle -= 2.0 * [Math]::PI
        }
        if ($Laser.Angle -le -[Math]::PI + $Epsilon) {
            $Laser.Angle += 2.0 * [Math]::PI
        }
        $Hits = Get-CollidingPrisms
    }

    Return $R

    <#
    .SYNOPSIS
    Finds the sequence of prisms hit by a laser.

    .DESCRIPTION
    Determines the order in which a laser beam encounters prisms based on
    the laser's starting position and angle. After hitting a prism, the
    laser is moved to that prism and its angle is adjusted by the prism's
    refraction angle.
    See visual demonstration for more details.

    .PARAMETER Laser
    Infomation about the laser.

    .PARAMETER Prisms
    Infomation about the prisms.
    #>
}

class Laser {
    [double]$X
    [double]$Y
    [double]$Angle

    Laser() {
        $this.X, $this.Y, $this.Angle = 0.0, 0.0, 0.0
    }
    Laser([double]$Ap) {
        # convert degrees to radians
        $this.X, $this.Y, $this.Angle = 0.0, 0.0, ($Ap * [Math]::PI / 180.0)
    }
}

class Prism {
    [int]$Id
    [double]$X
    [double]$Y
    [double]$Angle

    Prism([int]$IdP, [double]$Xp, [double]$Yp, [double]$Ap) {
        $this.Id, $this.X, $this.Y, $this.Angle = $IdP, $Xp, $Yp
        # convert degrees to radians
        $this.Angle = $Ap * [Math]::PI / 180.0
    }
}
