Function Invoke-Encode() {
    [CmdletBinding()]
    Param(
        [string]$Phrase
    )

    $Lower = $Phrase.ToLower()
    $Result = $Cipher = ""
    for ($i = $r = 0; $i -lt $Phrase.Length; $i++) {
        $Plain = $Lower[$i]
        if ($Plain -ge '0' -and $Plain -le '9') {
            $Cipher = $Plain
        }
        elseif ($Plain -ge 'a' -and $Plain -le 'z') {
            $Cipher = [char]([char]'z' - $Plain + [char]'a')
        }
        else {
            $Cipher = ""
        }
        if ($Cipher -ne "") {
            if ($r -eq 5) { $Result += " "; $r = 0}
            $Result += $Cipher
            $r++
        }
    }
    Return $Result
    <#
    .SYNOPSIS
    Encode a string using the Atbash cipher.

    .DESCRIPTION
    The Atbash cipher is a simple substitution cipher that relies on transposing all the letters in the 
    alphabet such that the resulting alphabet is backwards. 
    The first letter is replaced with the last letter, the second with the second-last, and so on.

    .PARAMETER Phrase
    The string to encode.

    .EXAMPLE
    Invoke-Encode -Phrase "yes"
    #>
}

Function Invoke-Decode() {
    [CmdletBinding()]
    Param(
        [string]$Phrase
    )

    $Result = ""
    for ($i = 0; $i -lt $Phrase.Length; $i++) {
        $Cipher = $Phrase[$i]
        if ($Cipher -ge '0' -and $Cipher -le '9') {
            $Result += $Cipher
        }
        elseif ($Cipher -ge 'a' -and $Cipher -le 'z') {
            $Plain = [char]([char]'z' - $Cipher + [char]'a')
            $Result += $Plain
        }
    }
    Return $Result    
    <#
    .SYNOPSIS
    Decode a string using the Atbash cipher.

    .DESCRIPTION
    The Atbash cipher is a simple substitution cipher that relies on transposing all the letters in the 
    alphabet such that the resulting alphabet is backwards. 
    The first letter is replaced with the last letter, the second with the second-last, and so on.

    .PARAMETER Phrase
    The string to decode.

    .EXAMPLE
    Invoke-Decode -Phrase "yes"
    #>
}
