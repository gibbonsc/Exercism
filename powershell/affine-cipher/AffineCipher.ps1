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

Function Invoke-Encode() {
    [CmdletBinding()]
    Param(
        [string]$Plaintext,
        [hashtable]$Keys
    )

    if (1 -ne (Get-Gcd 26 $Keys['a'])) { throw "a and m must be coprime" }

    $anchor = [int][char]'a'
    $L = $Plaintext.Length;
    $PTs = [int[]][char[]]($Plaintext.ToLower())
    $CT = ""
    $CTs = @()
    for ($ci = 0; $ci -lt $L; $ci++) {
        $I = $PTs[$ci]
        if ($anchor -le $I -and $I -le [int][char]'z') {
            $I -= $anchor
            $I = ($Keys['a'] * $I + $Keys['b']) % 26
            $I += $anchor
            $CT += [char]$I
        }
        elseif ([int][char]'0' -le $I -and $I -le [int][char]'9') {
            $CT += [char]$I
        }
        if ($CT.Length -eq 5) {
            $CTs += , $CT
            $CT = ""
        }
    }

    if ("" -ne $CT) { $CTs += , $CT }
    return $CTs -join " "

    <#
    .SYNOPSIS
    Use the affine cipher, an ancient encryption system created in the Middle East to encrypt text.

    .DESCRIPTION
    The encryption function is: E(x) = (ai + b) mod m
    
    i is the letter's index from 0 to the length of the alphabet - 1
    m is the length of the alphabet. For the Roman alphabet m is 26.
    a and b are integers which make the encryption key
    Values a and m must be coprime, if not you should throw error.

    .PARAMETER Plaintext
    The text to be encrypted.

    .PARAMETER Keys
    A hashtable contain the pair of keys `a` and `b`.

    .EXAMPLE
    Invoke-Encode -Plaintext "test" -Keys @{a = 5; b = 7}
    Returns: "ybty"
    #>
}

Function Invoke-Decode() {
    [CmdletBinding()]
    Param(
        [string]$Ciphertext,
        [hashtable]$Keys
    )

    if (1 -ne (Get-Gcd 26 $Keys['a'])) { throw "a and m must be coprime" }

    # construct affine inverse table
    $aInv = [int[]]::new(26)
    for ($ci = 0; $ci -lt 26; $ci++) {
        $y = ($Keys['a'] * $ci + $Keys['b']) % 26
        $aInv[$y] = $ci
    }

    $anchor = [int][char]'a'
    $L = $Ciphertext.Length;
    $CTs = [int[]][char[]]($Ciphertext.ToLower())
    $PT = ""
    for ($pi = 0; $pi -lt $L; $pi++) {
        $y = $CTs[$pi]
        if ($anchor -le $y -and $y -le [int][char]'z') {
            $y -= $anchor
            $y = $aInv[$y]
            $y += $anchor
            $PT += [char]$y
        }
        elseif ([int][char]'0' -le $y -and $y -le [int][char]'9') {
            $PT += [char]$y
        }
    }

    return $PT

    <#
    .SYNOPSIS
    Use the affine cipher, an ancient encryption system created in the Middle East to decrypt ciphertext.

    .DESCRIPTION
    The decryption function is: D(y) = (a^-1)(y - b) mod m
    
    y is the numeric value of an encrypted letter, i.e., y = E(x)
    it is important to note that a^-1 is the modular multiplicative inverse (MMI) of a mod m
    the modular multiplicative inverse only exists if a and m are coprime, if they are not you should throw error.
    The MMI of a is x such that the remainder after dividing ax by m is 1: ax mod m = 1

    .PARAMETER Ciphertext
    The text to be decrypted.

    .PARAMETER Keys
    A hashtable contain the pair of keys `a` and `b`.

    .EXAMPLE
    Invoke-Decode -Ciphertext "ybty" -Keys @{a = 5; b = 7}
    Returns: "test"
     #>
}
