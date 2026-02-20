Function Invoke-RotationalCipher() {
    [CmdletBinding()]
    Param(
        [string]$Text, 
        [int]$Shift
    )

    $Result = $RotChar = ""
    for ($i = 0; $i -lt $Text.Length; $i++) {
        $Char = $Text[$i]
        if ($Char -ge 'A' -and $Char -le 'Z') {
            $CharCode = [int][char]$Char
            $Offset = [int][char]'A'
            $RotCode = (($CharCode - $Offset + $Shift) % 26 + $Offset)
            $RotChar = [char]$RotCode
        }
        elseif ($Char -ge 'a' -and $Char -le 'z') {
            $CharCode = [int][char]$Char
            $Offset = [int][char]'a'
            $RotCode = (($CharCode - $Offset + $Shift) % 26 + $Offset)
            $RotChar = [char]$RotCode
        }
        else {
            $RotChar = $Char
        }
        $Result += $RotChar
    }
    Return $Result
    <#
    .SYNOPSIS
    Rotate a string by a given number of places.

    .DESCRIPTION
    Create an implementation of the rotational cipher, also sometimes called the Caesar cipher.
    
    .PARAMETER Text
    The text to rotate    

    .PARAMETER Shift
    The number of places to shift the text

    .EXAMPLE
    Invoke-RotationalCipher -Text "A" -Shift 1
    #>
}