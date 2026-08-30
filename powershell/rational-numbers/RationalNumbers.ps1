<# Update: added an overloaded less-than comparison operator (-lt)
    to the class, inspired by section 4.5.1 exercise 1 in
    D. E. Knuth, The Art of Computer Programming 3e vol 2.

    (Five pester test cases shown below.)
#>

Function Get-Gcd {
    [CmdletBinding()]
    Param(
        [uint]$A,
        [uint]$B
    )
    if ($A -eq 0) { return $B }
    if ($B -eq 0) { return $A }
    $K = 0
    while ((($A -bor $B) -band 1) -eq 0) { $A = $A -shr 1; $B = $B -shr 1; $K++ }
    while (($A -band 1) -eq 0) { $A = $A -shr 1 }
    while ($B -gt 0) {
        while (($B -band 1) -eq 0) { $B = $B -shr 1 }
        if ($B -lt $A) { $A, $B = $B, $A }
        $B -= $A
    }
    return $A -shl $K
}

Class Rational : IComparable {  # need IComparable for its CompareTo method
    [int] $Numer
    [int] $Denom

    Rational([int]$n, [int]$d) {
        if ($d -lt 0) { $n, $d = - $n, - $d }
        $un = ($n -lt 0) ? - $n : $n
        $gcd = Get-Gcd $un $d
        $this.Numer = $n / $gcd
        $this.Denom = $d / $gcd
    }

    [bool] Equals($other) {
        return ($this.Numer -eq $other.Numer) -and ($this.Denom -eq $other.Denom)
    }

    [int] CompareTo([object]$obj) {
        if ($obj -isnot [Rational]) {
            throw "Cannot compare Rational with $($obj.GetType().Name)"
        }
        $peer = [Rational]$obj

        $det = ($this.Numer * $peer.Denom) - ($this.denom * $peer.Numer)
        return [Math]::Sign($det)
    }

    static [bool] op_LessThan([Rational]$q, [Rational]$r) {
        return $q.CompareTo($r) -lt 0
    }

    [string] ToString() {
        return "$($this.Numer)/$($this.Denom)"
    }

    static [Rational] op_Addition([Rational]$q, [Rational]$r) {
        return [Rational]::new(
            $q.Numer * $r.Denom + $r.Numer * $q.Denom,
            $q.Denom * $r.Denom
        )
    }

    static [Rational] op_Subtraction([Rational]$q, [Rational]$r) {
        return [Rational]::new(
            $q.Numer * $r.Denom - $r.Numer * $q.Denom,
            $q.Denom * $r.Denom
        )
    }

    static [Rational] op_Multiply([Rational]$q, [Rational]$r) {
        return [Rational]::new(
            $q.Numer * $r.Numer,
            $q.Denom * $r.Denom
        )
    }

    static [Rational] op_Division([Rational]$q, [Rational]$r) {
        return [Rational]::new(
            $q.Numer * $r.Denom,
            $q.Denom * $r.Numer
        )
    }

    [Rational] Abs() {
        return $this.Numer -lt 0 ?
        [Rational]::new(-$this.Numer, $this.Denom) :
        [Rational]::new($this.Numer, $this.Denom)
    }

    [Rational] Power([int]$N) {
        if (0 -le $N) {
            return [Rational]::new(
                [Math]::Pow($this.Numer, $N),
                [Math]::Pow($this.Denom, $N)
            )
        }
        else {
            return [Rational]::new(
                [Math]::Pow($this.Denom, -$N),
                [Math]::Pow($this.Numer, -$N)
            )
        }
    }
    [double] Power([double]$X) {
        return [Math]::Pow($this.Numer, $X) / [Math]::Pow($this.Denom, $X)
    }

    [double] ReversePower([double]$X) {
        return [Math]::Pow(
            [Math]::Pow($X, $this.Numer),
            1.0 / $this.Denom
        )
    }
}

<#
.SYNOPSIS
    Implement a class represent a rational number.

.DESCRIPTION
    A rational number is defined as the quotient of two integers 'a' (numerator) and 'b' (denominator) where 'b != 0'.
    Please implement the following operations:
    - addition, subtraction, multiplication and division of two rational numbers,
    - absolute value, exponentiation of a given rational number to an integer power, exponentiation of a given rational number to a real (floating-point) power, exponentiation of a real number to a rational number.
    Your implementation of rational numbers should always be reduced to lowest terms.
    For example, `4/4` should reduce to `1/1`, `30/60` should reduce to `1/2`, `12/8` should reduce to `3/2`, etc.
    
.EXAMPLE
    $r1 = [Rational]::new(3,4)
    $r2 = [Rational]::new(5,6)

    $add = $r1 + $r2
    $add.ToString()
    Return: 19/12

    $sub = $r1 - $r2
    $sub.ToString()
    Return: -1/12

    $exp = $r1.Power(2)
    $exp.ToString()
    Return: 9/16
#>

<# Additional Pester test cases for -lt operator

    # Context "Order Comparisons (op_LessThan)" {
    #     It "sixty percent is less than two thirds" {
    #         $got  = [Rational]::new(3, 5) -lt [Rational]::new(2, 3)
    #         $got | Should -BeExactly $true
    #     }

    #     It "PI approximations: 22/7 is greater than 179/57" {
    #         $got  = [Rational]::new(22, 7) -lt [Rational]::new(179, 57)
    #         $got | Should -BeExactly $false
    #     }

    #     It "PI approximations: 355/113 is greater than 52163/16604" {
    #         $got  = [Rational]::new(355, 113) -lt [Rational]::new(52163, 16604)
    #         $got | Should -BeExactly $false
    #     }

    #     It "PI approximations: 52163/16604 is less than 52518/16717" {
    #         $got  = [Rational]::new(52163, 16604) -lt [Rational]::new(52518, 16717)
    #         $got | Should -BeExactly $true
    #     }

    #     It "0.4999 is less than 0.5001" {
    #         $got  = [Rational]::new(4999, 10000) -lt [Rational]::new(5001, 10000)
    #         $got | Should -BeExactly $true
    #     }
    # }
#>
