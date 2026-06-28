BeforeAll {
    . "./PiecingItTogether.ps1"
}

Describe "PiecingItTogether test cases" {
    BeforeEach {
        $puzzle = [JigsawPuzzle]::new()
    }
    It "1000 pieces puzzle with 1.6 aspect ratio" {
        $partialData = [PSCustomObject]@{
            Pieces = 1000
            AspectRatio = 1.6
        }
        $puzzle.GetData($partialData)

        $puzzle.Pieces      | Should -Be 1000
        $puzzle.Border      | Should -Be 126
        $puzzle.Inside      | Should -Be 874
        $puzzle.Rows        | Should -Be 25
        $puzzle.Columns     | Should -Be 40
        $puzzle.AspectRatio | Should -Be 1.6
        $puzzle.Format      | Should -Be ([Format]::Landscape)
    }

    It "square puzzle with 32 rows" {
        $partialData = [PSCustomObject]@{
            Rows = 32
            Format = [Format]::Square
        }
        $puzzle.GetData($partialData)

        $puzzle.Pieces      | Should -Be 1024
        $puzzle.Border      | Should -Be 124
        $puzzle.Inside      | Should -Be 900
        $puzzle.Rows        | Should -Be 32
        $puzzle.Columns     | Should -Be 32
        $puzzle.AspectRatio | Should -Be 1.0
        $puzzle.Format      | Should -Be ([Format]::Square)
    }

    It "400 pieces square puzzle with only inside pieces and aspect ratio" {
        $partialData = [PSCustomObject]@{
            Inside = 324
            AspectRatio = 1.0
        }
        $puzzle.GetData($partialData)

        $puzzle.Pieces      | Should -Be 400
        $puzzle.Border      | Should -Be 76
        $puzzle.Inside      | Should -Be 324
        $puzzle.Rows        | Should -Be 20
        $puzzle.Columns     | Should -Be 20
        $puzzle.AspectRatio | Should -Be 1.0
        $puzzle.Format      | Should -Be ([Format]::Square)
    }

    It "1500 pieces landscape puzzle with 30 rows and 1.6 aspect ratio" {
        $partialData = [PSCustomObject]@{
            Rows = 30
            AspectRatio = 1.6666666666666667
        }
        $puzzle.GetData($partialData)

        $puzzle.Pieces      | Should -Be 1500
        $puzzle.Border      | Should -Be 156
        $puzzle.Inside      | Should -Be 1344
        $puzzle.Rows        | Should -Be 30
        $puzzle.Columns     | Should -Be 50
        $puzzle.AspectRatio | Should -Be 1.6666666666666667
        $puzzle.Format      | Should -Be ([Format]::Landscape)
    }

    It "300 pieces portrait puzzle with 70 border pieces" {
        $partialData = [PSCustomObject]@{
            Pieces = 300
            Border = 70
            Format = [Format]::Portrait
        }
        $puzzle.GetData($partialData)

        $puzzle.Pieces      | Should -Be 300
        $puzzle.Border      | Should -Be 70
        $puzzle.Inside      | Should -Be 230
        $puzzle.Rows        | Should -Be 25
        $puzzle.Columns     | Should -Be 12
        $puzzle.AspectRatio | Should -Be 0.48
        $puzzle.Format      | Should -Be ([Format]::Portrait)
    }

    It "puzzle with insufficient data" {
        $partialData = [PSCustomObject]@{
            Pieces = 1500
            Format = [Format]::Landscape
        }
        { $puzzle.GetData($partialData) } | Should -Throw "*insufficient data*"
    }

    It "puzzle with contradictory data" {
        $partialData = [PSCustomObject]@{
            Rows = 100
            Columns = 1000
            Format = [Format]::Square
        }
        { $puzzle.GetData($partialData) } | Should -Throw "*contradictory data*"
    }

    # extra tests (mine, not Exercism's)
    It "1080 pieces, 36 columns" {
        $pd = [PSCustomObject]@{ Pieces = 1080; Columns = 36 }
        $puzzle.GetData($pd)

        $puzzle.Pieces      | Should -Be 1080
        $puzzle.Columns     | Should -Be   36
        $puzzle.Rows        | Should -Be   30
        $puzzle.Border      | Should -Be  128
        $puzzle.Inside      | Should -Be  952
        $puzzle.AspectRatio | Should -Be    1.2
        $puzzle.Format      | Should -Be ([Format]::Landscape)
    }
    It "14 columns, 156 inside" {
        $pd = [PSCustomObject]@{ Columns = 14; Inside = 156 }
        $puzzle.GetData($pd)

        $puzzle.Pieces      | Should -Be 210
        $puzzle.Columns     | Should -Be  14
        $puzzle.Rows        | Should -Be  15
        $puzzle.Border      | Should -Be  54
        $puzzle.Inside      | Should -Be 156
        $puzzle.AspectRatio | Should -Be  (14.0 / 15.0)
        $puzzle.Format      | Should -Be ([Format]::Portrait)
    }
    It "10 columns, 32 border" {
        $pd = [PSCustomObject]@{ Columns = 10; Border = 40 }
        $puzzle.GetData($pd)

        $puzzle.Pieces      | Should -Be 120
        $puzzle.Columns     | Should -Be  10
        $puzzle.Rows        | Should -Be  12
        $puzzle.Border      | Should -Be  40
        $puzzle.Inside      | Should -Be  80
        $puzzle.AspectRatio | Should -Be  (10.0 / 12.0)
        $puzzle.Format      | Should -Be ([Format]::Portrait)
    }
    It "9 columns, 0.9 aspect rato" {
        $pd = [PSCustomObject]@{ Columns = 9; AspectRatio = 0.9 }
        $puzzle.GetData($pd)

        $puzzle.Pieces      | Should -Be 90
        $puzzle.Columns     | Should -Be  9
        $puzzle.Rows        | Should -Be 10
        $puzzle.Border      | Should -Be 34
        $puzzle.Inside      | Should -Be 56
        $puzzle.AspectRatio | Should -Be  0.9
        $puzzle.Format      | Should -Be ([Format]::Portrait)
    }
    It "7500 pieces, 75 rows" {
        $pd = [PSCustomObject]@{ Pieces = 7500; Rows = 75 }
        $puzzle.GetData($pd)

        $puzzle.Pieces      | Should -Be 7500
        $puzzle.Columns     | Should -Be  100
        $puzzle.Rows        | Should -Be   75
        $puzzle.Border      | Should -Be  346
        $puzzle.Inside      | Should -Be 7154
        $puzzle.AspectRatio | Should -Be (100.0 / 75.0)
        $puzzle.Format      | Should -Be ([Format]::Landscape)
    }
    It "366 border, 125 rows" {
        $pd = [PSCustomObject]@{ Border = 366; Rows = 125 }
        $puzzle.GetData($pd)

        $puzzle.Pieces      | Should -Be 7500
        $puzzle.Columns     | Should -Be   60
        $puzzle.Rows        | Should -Be  125
        $puzzle.Border      | Should -Be  366
        $puzzle.Inside      | Should -Be 7134
        $puzzle.AspectRatio | Should -Be    0.48
        $puzzle.Format      | Should -Be ([Format]::Portrait)
    }
    It "3975 inside, 4235 rows, landscape" {
        $pd = [PSCustomObject]@{ Inside = 3975; Rows = 55 }
        $puzzle.GetData($pd)

        $puzzle.Pieces      | Should -Be 4235
        $puzzle.Columns     | Should -Be   77
        $puzzle.Rows        | Should -Be   55
        $puzzle.Border      | Should -Be  260
        $puzzle.Inside      | Should -Be 3975
        $puzzle.AspectRatio | Should -Be    1.4
        $puzzle.Format      | Should -Be ([Format]::Landscape)
    }
    It "landscape, 100 border, 672 pieces" {
        $pd = [PSCustomObject]@{
            Border = 100; Format = [Format]::Landscape; Pieces = 672
        }
        $puzzle.GetData($pd)

        $puzzle.Pieces      | Should -Be  672
        $puzzle.Columns     | Should -Be   28
        $puzzle.Rows        | Should -Be   24
        $puzzle.Border      | Should -Be  100
        $puzzle.Inside      | Should -Be  572
        $puzzle.AspectRatio | Should -Be   (7.0/6.0)
        $puzzle.Format      | Should -Be ([Format]::Landscape)
    }
    It "landscape, 100 inside, 162 pieces" {
        $pd = [PSCustomObject]@{
            Inside = 100; Format = [Format]::Landscape; Pieces = 162
        }
        $puzzle.GetData($pd)

        $puzzle.Pieces      | Should -Be  162
        $puzzle.Columns     | Should -Be   27
        $puzzle.Rows        | Should -Be    6
        $puzzle.Border      | Should -Be   62
        $puzzle.Inside      | Should -Be  100
        $puzzle.AspectRatio | Should -Be    4.5
        $puzzle.Format      | Should -Be ([Format]::Landscape)
    }
    It "portrait, 7134 inside, 7500 pieces" {
        $pd = [PSCustomObject]@{
            Inside = 7134; Format = [Format]::Portrait; Pieces = 7500
        }
        $puzzle.GetData($pd)

        $puzzle.Pieces      | Should -Be 7500
        $puzzle.Columns     | Should -Be   60
        $puzzle.Rows        | Should -Be  125
        $puzzle.Border      | Should -Be  366
        $puzzle.Inside      | Should -Be 7134
        $puzzle.AspectRatio | Should -Be    0.48
        $puzzle.Format      | Should -Be ([Format]::Portrait)
    }

}
