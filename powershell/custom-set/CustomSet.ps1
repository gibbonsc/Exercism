Class CustomSet {
    [Hashtable]$Elements

    CustomSet() {
        $this.Elements = [Hashtable]::new()
    }
    CustomSet([CustomSet]$C) {
        $this.Elements = [Hashtable]::new()
        foreach ($K in $C.Elements.Keys) {
            $this.Elements[$K] = $true
        }
    }
    CustomSet([Object[]]$InitSet) {
        $this.Elements = [Hashtable]::new()
        foreach ($O in $InitSet) {
            $this.Elements[$O] = $true
        }
    }

    [bool] IsEmpty() {
        return $this.Elements.Count -eq 0
    }
    
    [bool] Contains($element) {
        return $this.Elements.ContainsKey($element)
    }

    [bool] IsSubset($other) {
        foreach ($K in $this.Elements.Keys) {
            if (-not $other.Contains($K)) {
                return $false
            }
        }
        return $true
    }

    [bool] IsDisjoint($other) {
        foreach ($K in $this.Elements.Keys) {
            if ($other.Contains($K)) {
                return $false
            }
        }
        foreach ($K in $other.Elements.Keys) {
            if ($this.Elements.Contains($K)) {
                return $false
            }
        }
        return $true
    }

    [CustomSet] Add($element) {
        $Result = [CustomSet]::new($this)
        $Result.Elements[$element] = $true
        return $Result
    }

    [CustomSet] Union($other) {
        $Result = [CustomSet]::new($other)
        foreach ($K in $this.Elements.Keys) {
            $Result = $Result.Add($K)
        }
        return $Result
    }

    [bool] Equals($other) {
        foreach ($K in $this.Elements.Keys) {
            if (-not $other.Contains($K)) {
                return $false
            }
        }
        foreach ($K in $other.Elements.Keys) {
            if (-not $this.Elements.Contains($K)) {
                return $false
            }
        }
        return $true
    }
    
    [CustomSet] Difference($other) {
        $Result = [CustomSet]::new()
        foreach ($K in $this.Elements.Keys) {
            if (-not $other.Contains($K)) {
                $Result = $Result.Add($K)
            }
        }
        return $Result
    }

    [CustomSet] Intersection($other) {
        $Result = [CustomSet]::new()
        foreach ($K in $this.Elements.Keys) {
            if ($other.Contains($K)) {
                $Result = $Result.Add($K)
            }
        }
        return $Result
    }
}
<#
.SYNOPSIS
    Implement a custom set data type.

.DESCRIPTION
    Implement a class CustomSet to represent the set data structure with its typical behaviors and methods.
    Set behavior: elements inside a set are unique. 
    Set methods: IsEmpty, Contains, IsSubset, IsDisjoint, Add, Union, Difference and Intersection.

    How it being contructed internally doesn't matter, but the class also need an 'Equals' method to compare with other set.

.EXAMPLE
    $set  = [CustomSet]::new(@(3, 4, 5))
    $set2 = [CustomSet]::new(@(3, 2, 4, 5, 1))

    $set.IsEmpty()
    Returns: $false

    $set.Contains(3)
    Returns: $true

    $set.IsSubset($set2)
    Returns: $true
#>
