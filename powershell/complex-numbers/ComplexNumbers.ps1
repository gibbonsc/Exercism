class ComplexNumber : System.IEquatable[Object] {
    [double]$real
    [double]$imaginary

    ComplexNumber([double]$r,[double]$i) {
        $this.real, $this.imaginary = $r, $i
    }
    ComplexNumber([double]$r) {
        $this.real, $this.imaginary = $r, 0
    }

    [double] Abs() {
        return [Math]::Sqrt(
                $this.real * $this.real +
                $this.imaginary * $this.imaginary
        )
    }

    static [ComplexNumber] op_Addition([ComplexNumber]$c, [ComplexNumber]$k) {
        return [ComplexNumber]::new(
            $c.real + $k.real, $c.imaginary + $k.imaginary
        )
    }

    static [ComplexNumber] op_Subtraction([ComplexNumber]$c, [ComplexNumber]$k) {
        return [ComplexNumber]::new(
            $c.real - $k.real, $c.imaginary - $k.imaginary
        )
    }

    [bool] Equals([Object]$c) {
        return 1.0E-15 -gt ($this - $c).Abs()
    }

    static [ComplexNumber] op_Multiply([ComplexNumber]$c, [ComplexNumber]$k) {
        return [ComplexNumber]::new(
            $c.real * $k.real - $c.imaginary * $k.imaginary,
            $c.imaginary * $k.real + $c.real * $k.imaginary
        )
    }

    static [ComplexNumber] Reciprocal([ComplexNumber]$c) {
        return [ComplexNumber]::new(
            $c.real / ($c.real * $c.real + $c.imaginary * $c.imaginary),
            $c.imaginary / ($c.real * $c.real + $c.imaginary * $c.imaginary)
        )
    }

    static [ComplexNumber] op_Division([ComplexNumber]$c, [ComplexNumber]$k) {
        return [ComplexNumber]::new(
            ($c.real * $k.real + $c.imaginary * $k.imaginary) /
                ($k.real * $k.real + $k.imaginary * $k.imaginary),
            ($c.imaginary * $k.real - $c.real * $k.imaginary) /
                ($k.real * $k.real + $k.imaginary * $k.imaginary)
        )
    }

    [ComplexNumber] Conjugate() {
        return [ComplexNumber]::new($this.real, -$this.imaginary)
    }

    [ComplexNumber] Exp() {
        return [ComplexNumber]::new(
            [Math]::Exp($this.real) * [Math]::Cos($this.imaginary),
            [Math]::Exp($this.real) * [Math]::Sin($this.imaginary)
        )
    }
}
<#
.SYNOPSIS
    Implement a class represent a complex number.
.DESCRIPTION
    A complex number is a number in the form 'a + b * i' where 'a' and 'b' are real and 'i' satisfies 'i^2 = -1'.
    Please Implement the following operations:
    - addition, subtraction, multiplication and division of two complex numbers,
    - conjugate, absolute value, exponent of a given complex number.
    
.EXAMPLE
    $comp = [ComplexNumber]::new(-1,2)
    $comp2 = [ComplexNumber]::new(3,-4)
    $sum = $comp + $comp2
    $sum.real
    Return: 2
    $sum.imaginary
    Return: -2
    $comp2.Abs()
    Return: 5
#>
