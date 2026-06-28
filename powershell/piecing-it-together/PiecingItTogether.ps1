enum Format {
    Undetermined
    Portrait
    Square
    Landscape
}

class JigsawPuzzle {
    [int]$Pieces = 0
    [int]$Border = 0
    [int]$Inside = 0
    [int]$Columns = 0
    [int]$Rows = 0
    [double]$AspectRatio = 0.0
    [Format]$Format = [Format]::Undetermined

    hidden [bool] ConsistencyCheck(
        [int]$P,
        [int]$B,
        [int]$I,
        [int]$C,
        [int]$R,
        [double]$A,
        [Format]$F
    ) {
        return $this.Pieces -eq $P -and
            $this.Border -eq $B -and
            $this.Inside -eq $I -and
            $this.Columns -eq $C -and
            $this.Rows -eq $R -and
            $this.AspectRatio -eq $A -and
            $this.Format -eq $F
    }

    [void] GetData([PSCustomObject]$partialData)
    {
        # ingest provided fields
        $dataNames = (
            $partialData | Get-Member -MemberType NoteProperty
            ).Name
        foreach ($n in $dataNames) {
            $this.$n = $partialData.($n)
        }

        # register values of all fields, whether provided or not
        $P, $B, $I, $C, $R, $A, $F =
            $this.Pieces,
            $this.Border,
            $this.Inside,
            $this.Columns,
            $this.Rows,
            $this.AspectRatio,
            $this.Format

        # Try to calculate remaining fields according to constraints.
        # Given these two constraints, the other five may be determined.
        # Examples:
        #   from dimensions r and c, pieces p = r*c
        #   from pieces p and a dimension d (r or c), other dim. = p/d
        #   from border b and a dimension d (r or c), other dim. = b/2+2-d
        #   from inside i and a dimension d (r or c), other dim. = 2+i/(d-2)
        #   from aspect ratio a and columns c, rows r=c/a
        #   from aspect ratio a and rows r, columns c=a*r
        #   from aspect ratio a and border b, rows r=(b+4)/2/(1+a)
        #   from aspect ratio a and inside i, rows r=
        #     (1+a+sqrt((a-1)*(a-1)+a*i))/a
        #   from pieces p and aspect ratio a, cols c=sqrt(p*a)
        #   from pieces p and format f = square: r = c = sqrt(p)
        # Given these two constraints, one other may be determined:
        #   from border b and inside i, pieces p = b+i
        #   from pieces p and partition t (b or i), other partition = p-t
        # Given these three constraints, the other four may be determined:
        #    p, partition (b or i), and format f > 1:
        #      r = (s + sqrt(s*s-4*p))/2 with s = b/2+2
        #    p, partition (b or i), and format f < 1:
        #      r = (s - sqrt(s*s-4*p))/2 with s = b/2+2

        if ($F -eq [Format]::Square) {
            $dataNames += , 'AspectRatio'
            $A = 1.0
            if (0.0 -eq $this.AspectRatio) { $this.AspectRatio = $A }
        }

        if ('Columns' -in $dataNames) {
            if ('Rows' -in $dataNames) {
                $P = $C * $R
                if (0 -eq $this.Pieces) { $this.Pieces = $P }
                $B = $C * 2 + $R * 2 - 4
                if (0 -eq $this.Border) { $this.Border = $B }
                $I = $P - $B
                if (0 -eq $this.Inside) { $this.Inside = $I }
                $A = $C / $R
                if (0.0 -eq $this.AspectRatio) { $this.AspectRatio = $A }
                $F = $R -eq $C ? [Format]::Square :
                    ($R -gt $C ? [Format]::Portrait : [Format]::Landscape)
                if ([Format]::Undetermined -eq $this.Format) {
                    $this.Format = $F
                }
            }
            elseif ('Pieces' -in $dataNames) {
                $R = $P / $C
                if (0 -eq $this.Rows) { $this.Rows = $R }
                $B = $C * 2 + $R * 2 - 4
                if (0 -eq $this.Border) { $this.Border = $B }
                $I = $P - $B
                if (0 -eq $this.Inside) { $this.Inside = $I }
                $A = $C / $R
                if (0.0 -eq $this.AspectRatio) { $this.AspectRatio = $A }
                $F = $R -eq $C ? [Format]::Square :
                    ($R -gt $C ? [Format]::Portrait : [Format]::Landscape)
                if ([Format]::Undetermined -eq $this.Format) {
                    $this.Format = $F
                }
            }
            elseif ('Inside' -in $dataNames) {
                $R = 2 + $I / ($C - 2)
                if (0 -eq $this.Rows) { $this.Rows = $R }
                $P = $C * $R
                if (0 -eq $this.Pieces) { $this.Pieces = $P }
                $B = $P - $I
                if (0 -eq $this.Border) { $this.Border = $B }
                $A = $C / $R
                if (0.0 -eq $this.AspectRatio) { $this.AspectRatio = $A }
                $F = $R -eq $C ? [Format]::Square :
                    ($R -gt $C ? [Format]::Portrait : [Format]::Landscape)
                if ([Format]::Undetermined -eq $this.Format) {
                    $this.Format = $F
                }
            }
            elseif ('Border' -in $dataNames) {
                $R = $B / 2 + 2 - $C
                if (0 -eq $this.Rows) { $this.Rows = $R }
                $P = $C * $R
                if (0 -eq $this.Pieces) { $this.Pieces = $P }
                $I = $P - $B
                if (0 -eq $this.Inside) { $this.Inside = $I }
                $A = $C / $R
                if (0.0 -eq $this.AspectRatio) { $this.AspectRatio = $A }
                $F = $R -eq $C ? [Format]::Square :
                    ($R -gt $C ? [Format]::Portrait : [Format]::Landscape)
                if ([Format]::Undetermined -eq $this.Format) {
                    $this.Format = $F
                }
            }
            elseif ('AspectRatio' -in $dataNames) {
                $R = $C / $A
                if (0 -eq $this.Rows) { $this.Rows = $R }
                $P = $C * $R
                if (0 -eq $this.Pieces) { $this.Pieces = $P }
                $B = $C * 2 + $R * 2 - 4
                if (0 -eq $this.Border) { $this.Border = $B }
                $I = $P - $B
                if (0 -eq $this.Inside) { $this.Inside = $I }
                $F = $R -eq $C ? [Format]::Square :
                    ($R -gt $C ? [Format]::Portrait : [Format]::Landscape)
                if ([Format]::Undetermined -eq $this.Format) {
                    $this.Format = $F
                }
            }
        }
        elseif ('Rows' -in $dataNames) {
            if ('Pieces' -in $dataNames) {
                $C = $P / $R
                if (0 -eq $this.Columns) { $this.Columns = $C }
                $B = $C * 2 + $R * 2 - 4
                if (0 -eq $this.Border) { $this.Border = $B }
                $I = $P - $B
                if (0 -eq $this.Inside) { $this.Inside = $I }
                $A = $C / $R
                if (0.0 -eq $this.AspectRatio) { $this.AspectRatio = $A }
                $F = $R -eq $C ? [Format]::Square :
                    ($R -gt $C ? [Format]::Portrait : [Format]::Landscape)
                if ([Format]::Undetermined -eq $this.Format) {
                    $this.Format = $F
                }
            }
            elseif ('Border' -in $dataNames) {
                $C = $B / 2 + 2 - $R
                if (0 -eq $this.Columns) { $this.Columns = $C }
                $P = $R * $C
                if (0 -eq $this.Pieces) { $this.Pieces = $P }
                $I = $P - $B
                if (0 -eq $this.Inside) { $this.Inside = $I }
                $A = $C / $R
                if (0.0 -eq $this.AspectRatio) { $this.AspectRatio = $A }
                $F = $R -eq $C ? [Format]::Square :
                    ($R -gt $C ? [Format]::Portrait : [Format]::Landscape)
                if ([Format]::Undetermined -eq $this.Format) {
                    $this.Format = $F
                }
            }
            elseif ('Inside' -in $dataNames) {
                $C = 2 + $I / ($R - 2)
                if (0 -eq $this.Columns) { $this.Columns = $C }
                $P = $R * $C
                if (0 -eq $this.Pieces) { $this.Pieces = $P }
                $B = $P - $I
                if (0 -eq $this.Border) { $this.Border = $B }
                $A = $C / $R
                if (0.0 -eq $this.AspectRatio) { $this.AspectRatio = $A }
                $F = $R -eq $C ? [Format]::Square :
                    ($R -gt $C ? [Format]::Portrait : [Format]::Landscape)
                if ([Format]::Undetermined -eq $this.Format) {
                    $this.Format = $F
                }
            }
            elseif ('AspectRatio' -in $dataNames) {
                $C = $R * $A
                if (0 -eq $this.Columns) { $this.Columns = $C }
                $P = $R * $C
                if (0 -eq $this.Pieces) { $this.Pieces = $P }
                $B = $C * 2 + $R * 2 - 4
                if (0 -eq $this.Border) { $this.Border = $B }
                $I = $P - $B
                if (0 -eq $this.Inside) { $this.Inside = $I }
                $F = $R -eq $C ? [Format]::Square :
                    ($R -gt $C ? [Format]::Portrait : [Format]::Landscape)
                if ([Format]::Undetermined -eq $this.Format) {
                    $this.Format = $F
                }
            }
        }
        elseif ('AspectRatio' -in $dataNames) {
            if ('Border' -in $dataNames) {
                $R = ($B + 4) / 2 / (1 + $A)
                if (0 -eq $this.Rows) { $this.Rows = $R }
                $C = $A * $R
                if (0 -eq $this.Columns) { $this.Columns = $C }
                $P = $R * $C
                if (0 -eq $this.Pieces) { $this.Pieces = $P }
                $I = $P - $B
                if (0 -eq $this.Inside) { $this.Inside = $I }
                $F = $R -eq $C ? [Format]::Square :
                    ($R -gt $C ? [Format]::Portrait : [Format]::Landscape)
                if ([Format]::Undetermined -eq $this.Format) {
                    $this.Format = $F
                }
            }
            elseif ('Inside' -in $dataNames) {
                $C = (
                    1 + $A + [Math]::Sqrt(($A - 1) * ($A - 1) + $A * $I)
                    ) / $A
                if (0 -eq $this.Columns) { $this.Columns = $C }
                $R = $C / $A
                if (0 -eq $this.Rows) { $this.Rows = $R }
                $P = $R * $C
                if (0 -eq $this.Pieces) { $this.Pieces = $P }
                $B = $P - $I
                if (0 -eq $this.Border) { $this.Border = $B }
                $F = $R -eq $C ? [Format]::Square :
                    ($R -gt $C ? [Format]::Portrait : [Format]::Landscape)
                if ([Format]::Undetermined -eq $this.Format) {
                    $this.Format = $F
                }
            }
            elseif ('Pieces' -in $dataNames) {
                $C = [Math]::Sqrt($P * $A)
                if (0 -eq $this.Columns) { $this.Columns = $C }
                $R = $P / $C
                if (0 -eq $this.Rows) { $this.Rows = $R }
                $B = $C * 2 + $R * 2 - 4
                if (0 -eq $this.Border) { $this.Border = $B }
                $I = $P - $B
                if (0 -eq $this.Inside) { $this.Inside = $I }
                $F = $R -eq $C ? [Format]::Square :
                    ($R -gt $C ? [Format]::Portrait : [Format]::Landscape)
                if ([Format]::Undetermined -eq $this.Format) {
                    $this.Format = $F
                }
            }
        }
        elseif ('Format' -in $dataNames) {
            if ($F -eq [Format]::Portrait) {
                if ('Border' -in $dataNames -and 'Pieces' -in $dataNames) {
                    $I = $P - $B
                    if (0 -eq $this.Inside) { $this.Inside = $I }
                    $S = $B / 2 + 2
                    $R = ($S + [Math]::Sqrt($S * $S - 4 * $P)) / 2
                    if (0 -eq $this.Rows) { $this.Rows = $R }
                    $C = $P / $R
                    if (0 -eq $this.Columns) { $this.Columns = $C }
                    $A = $C / $R
                    if (0.0 -eq $this.AspectRatio) {
                        $this.AspectRatio = $A
                    }
                }
                elseif ('Inside' -in $dataNames -and 'Pieces' -in $dataNames) {
                    $B = $P - $I
                    if (0 -eq $this.Border) { $this.Border = $B }
                    $S = $B / 2 + 2
                    $R = ($S + [Math]::Sqrt($S * $S - 4 * $P)) / 2
                    if (0 -eq $this.Rows) { $this.Rows = $R }
                    $C = $P / $R
                    if (0 -eq $this.Columns) { $this.Columns = $C }
                    $A = $C / $R
                    if (0.0 -eq $this.AspectRatio) {
                        $this.AspectRatio = $A
                    }
                }
            }
            elseif ($F -eq [Format]::Landscape) {
                if ('Border' -in $dataNames -and 'Pieces' -in $dataNames) {
                    $I = $P - $B
                    if (0 -eq $this.Inside) { $this.Inside = $I }
                    $S = $B / 2 + 2
                    $R = ($S - [Math]::Sqrt($S * $S - 4 * $P)) / 2
                    if (0 -eq $this.Rows) { $this.Rows = $R }
                    $C = $P / $R
                    if (0 -eq $this.Columns) { $this.Columns = $C }
                    $A = $C / $R
                    if (0.0 -eq $this.AspectRatio) {
                        $this.AspectRatio = $A
                    }
                }
                elseif ('Inside' -in $dataNames -and 'Pieces' -in $dataNames) {
                    $B = $P - $I
                    if (0 -eq $this.Border) { $this.Border = $B }
                    $S = $B / 2 + 2
                    $R = ($S - [Math]::Sqrt($S * $S - 4 * $P)) / 2
                    if (0 -eq $this.Rows) { $this.Rows = $R }
                    $C = $P / $R
                    if (0 -eq $this.Columns) { $this.Columns = $C }
                    $A = $C / $R
                    if (0.0 -eq $this.AspectRatio) {
                        $this.AspectRatio = $A
                    }
                }
            }
        }
        if (-not $this.ConsistencyCheck(
            $P, $B, $I, $C, $R, $A, $F
        ) ) {
            throw "JigsawPuzzle got contradictory data"
        }
        if (
            (0 -in $P, $B, $I, $C, $R, $A) -or
            $F -eq [Format]::Undetermined
        ) {
            throw "JugsawPuzzle got insufficient data"
        }
    }
}

<#
.SYNOPSIS
Given partial information about a jigsaw puzzle, add the missing pieces.

.DESCRIPTION
Calculate properties of a jigsaw puzzle with given information if possible.
If not possible due to insufficient or incorrect information, the user should be notified.
Read instructions for more information and example.
#>
