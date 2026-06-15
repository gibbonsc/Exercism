BeforeAll {
    . "./KillerSudokuHelper.ps1"
}

Describe "KillerSudokuHelper test cases" {
    Context "Trivial 1-digit cages" {
        It "Trivial 1-digit cages -> 1" {
            $got  = Invoke-KillerSudokuHelper -Sum 1 -Size 1 -Exclude @()
            $want = @( @(1))
    
            $got | Should -BeExactly $want
        }
    
        It "Trivial 1-digit cages -> 2" {
            $got  = Invoke-KillerSudokuHelper -Sum 2 -Size 1 -Exclude @()
            $want = @( @(2))
    
            $got | Should -BeExactly $want
        }
    
        It "Trivial 1-digit cages -> 3" {
            $got  = Invoke-KillerSudokuHelper -Sum 3 -Size 1 -Exclude @()
            $want = @( @(3))
    
            $got | Should -BeExactly $want
        }
    
        It "Trivial 1-digit cages -> 4" {
            $got  = Invoke-KillerSudokuHelper -Sum 4 -Size 1 -Exclude @()
            $want = @( @(4))
    
            $got | Should -BeExactly $want
        }
    
        It "Trivial 1-digit cages -> 5" {
            $got  = Invoke-KillerSudokuHelper -Sum 5 -Size 1 -Exclude @()
            $want = @( @(5))
    
            $got | Should -BeExactly $want
        }
    
        It "Trivial 1-digit cages -> 6" {
            $got  = Invoke-KillerSudokuHelper -Sum 6 -Size 1 -Exclude @()
            $want = @( @(6))
    
            $got | Should -BeExactly $want
        }
    
        It "Trivial 1-digit cages -> 7" {
            $got  = Invoke-KillerSudokuHelper -Sum 7 -Size 1 -Exclude @()
            $want = @( @(7))
    
            $got | Should -BeExactly $want
        }
    
        It "Trivial 1-digit cages -> 8" {
            $got  = Invoke-KillerSudokuHelper -Sum 8 -Size 1 -Exclude @()
            $want = @( @(8))
    
            $got | Should -BeExactly $want
        }
    
        It "Trivial 1-digit cages -> 9" {
            $got  = Invoke-KillerSudokuHelper -Sum 9 -Size 1 -Exclude @()
            $want = @( @(9))
    
            $got | Should -BeExactly $want
        }
    }

    It "Cage with sum 45 contains all digits 1:9" {
        $got  = Invoke-KillerSudokuHelper -Sum 45 -Size 9 -Exclude @()
        $want = @( @(1, 2, 3, 4, 5, 6, 7, 8, 9))

        $got | Should -BeExactly $want
    }

    It "Cage with only 1 possible combination" {
        $got  = Invoke-KillerSudokuHelper -Sum 7 -Size 3 -Exclude @()
        $want = @( @(1, 2, 4))

        $got | Should -BeExactly $want
    }

    It "Cage with several combinations" {
        $got  = Invoke-KillerSudokuHelper -Sum 10 -Size 2 -Exclude @()
        $want = @( @(1, 9), @(2, 8), @(3, 7), @(4, 6))

        $got | Should -BeExactly $want
    }

    It "Cage with several combinations that is restricted" {
        $got  = Invoke-KillerSudokuHelper -Sum 10 -Size 2 -Exclude @(1, 4)
        $want = @( @(2, 8), @(3, 7))

        $got | Should -BeExactly $want
    }

    # I added a few extra tests (these are not official Exercism tests)
    It "Cage with just one 4-combination" {
        $got  = Invoke-KillerSudokuHelper -Sum 17 -Size 4 -Exclude @(1, 4)
        $want = @( @(2, 3, 5, 7))
        $got | Should -BeExactly $want
    }
    It "Cage with two 4-combinations" {
        $got  = Invoke-KillerSudokuHelper -Sum 18 -Size 4 -Exclude @(1, 4)
        $want = @( @(2, 3, 5, 8), @(2, 3, 6, 7))
        $got | Should -BeExactly $want
    }
    It "Cage with eleven 4-combinations" {
        $got  = Invoke-KillerSudokuHelper -Sum 22 -Size 4 -Exclude @()
        $want = @(
            @(1, 4, 8, 9),
            @(1, 5, 7, 9),
            @(1, 6, 7, 8),
            @(2, 3, 8, 9),
            @(2, 4, 7, 9),
            @(2, 5, 6, 9),
            @(2, 5, 7, 8),
            @(3, 4, 6, 9),
            @(3, 4, 7, 8),
            @(3, 5, 6, 8),
            @(4, 5, 6, 7)
        )
        $got | Should -BeExactly $want
    }
    It "Cage with eleven 4-combinations that is restricted" {
        $got  = Invoke-KillerSudokuHelper -Sum 22 -Size 4 -Exclude @(1, 3)
        $want = @(
            @(2, 4, 7, 9),
            @(2, 5, 6, 9),
            @(2, 5, 7, 8),
            @(4, 5, 6, 7)
        )
        $got | Should -BeExactly $want
    }
    It "Cage with sum of 10 and size of 3" {
        $got  = Invoke-KillerSudokuHelper -Sum 10 -Size 3 -Exclude @()
        $want = @( @(1,2,7), @(1,3,6), @(1,4,5), @(2,3,5) )

        $got | Should -BeExactly $want
    }
}
