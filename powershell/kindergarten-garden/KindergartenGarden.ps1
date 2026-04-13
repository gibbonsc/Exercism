enum Plants {
    Empty
    Clover
    Grass
    Radishes
    Violets
}

function MapLetterToPlant {
    [OutputType([Plants])]
    param([Parameter(Mandatory)][string]$Letter)

    [Plants]$P = switch ($Letter) {
        'C' { [Plants]::Clover; break }
        'G' { [Plants]::Grass; break }
        'R' { [Plants]::Radishes; break }
        'V' { [Plants]::Violets; break }
        default { [Plants]::Empty }
    }
    return $P
}

Class Garden {
    [Plants[][]]$SeedArray
    [string[]]$Students

    Constructor([string]$PlantDiagram, [string[]]$Kids) {
        if ($null -eq $Kids) {
            $this.Students =
                @("Alice", "Bob", "Charlie", "David", "Eve", "Fred",
                "Ginny", "Harriet", "Ileana", "Joseph", "Kincaid", "Larry")
        }
        else { $this.Students = $Kids | Sort-Object }
        $this.SeedArray = @()
        $Rows = $PlantDiagram -split "`n"
        for ($i = 0; $i -lt $Rows[0].Length / 2; $i++) {
            $this.SeedArray +=
                , @(MapLetterToPlant($Rows[0].SubString($i * 2, 1)))
            $this.SeedArray[$i] +=
                , (MapLetterToPlant($Rows[0].SubString($i * 2 + 1, 1)))
            $this.SeedArray[$i] +=
                , (MapLetterToPlant($Rows[1].SubString($i * 2, 1)))
            $this.SeedArray[$i] +=
                , (MapLetterToPlant($Rows[1].SubString($i * 2 + 1, 1)))
        }
    }

    Garden([string]$PlantDiagram) {
        $this.Constructor($PlantDiagram, $null)
    }

    Garden([string]$PlantDiagram, [string[]]$Children) {
        $this.Constructor($PlantDiagram, $Children)
    }

    [string[]]GetPlants([string]$Name) {
        $i = [Array]::IndexOf($this.Students, $Name)
        if ($i -lt 0) {
            throw "Name $Name not found"
        }
        else {
            return [string[]]$this.SeedArray[$i]
        }
    }
}

<#
.SYNOPSIS
    Given a diagram, determine which plants each child in the kindergarten class is responsible for.

.DESCRIPTION
    There are 12 children in the class:
    - Alice, Bob, Charlie, David,
    - Eve, Fred, Ginny, Harriet,
    - Ileana, Joseph, Kincaid, and Larry.
    Each child take care of 4 plants, two on each row.
    The children are being seated alphabetically from left to right.

    Note: the class constructor should accept an optional list of differnt students if provided.

.EXAMPLE
    $garden = [Garden]::new("VCCCGG`nVGCCGG")
    $garden.GetPlants("Alice")
    Return : @("Violets", "Clover", "Violets", "Grass")
#>
