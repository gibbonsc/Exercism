Class SimpleCipher {
    [string] $_key
    [sbyte[]] $Shifts

    hidden [void] MakeShifts() {
        $this.Shifts = @()
        foreach ($C in [char[]]$this._key) {
            $this.Shifts += , [sbyte]($C - [char]'a')
        }
    }

    SimpleCipher() {
        $this._key = -join (1..100 | ForEach-Object { 'a'..'z' | Get-Random })
        $this.MakeShifts()
    }

    SimpleCipher($Key) {
        $this._key = $Key
        $this.MakeShifts()
    }

    hidden [string] Transform([string]$Text, [bool]$Reverse) {
        $Letters = [sbyte[]][char[]]$Text | ForEach-Object {
            $_ - [sbyte][char]'a'
        }
        $Transformed = ""
        for ($i = 0; $i -lt $Letters.Length; $i++) {
            $Shift = $this.Shifts[$i % ($this.Shifts.Length)]
            if ($Reverse) { $Shift *= -1 }
            $Transformed += [string]([char](($Letters[$i] + $Shift + 26) % 26 + [sbyte][char]'a'))
        }
        return $Transformed
    }

    [string] Encode([string]$Plain) {
        return $this.Transform($Plain, $false)
    }

    [string] Decode($Cipher) {
        return $this.Transform($Cipher, $true)
    }
}

<#
.SYNOPSIS
Implement a simple shift cipher like Caesar and a more secure substitution cipher.

.DESCRIPTION
Implement a simple cipher class to encode or decode a message with a key.
If there was no key provided, generate one minumum 100 characters long contains only lower case letter (a-z).

.EXAMPLE
$cipher = [SimpleCipher]::new("mykey")

$cipher.Encode("aaaaa")
Return: "mykey"

$cipher.Decode("ecmvcf")
Return: "secret"
#>
