Function Invoke-SecretHandshake() {
    [CmdletBinding()] Param([int]$Number)

    $Wink = $Number -band 0b1
    $DoubleBLink = $Number -band 0b10
    $CloseYourEyes = $Number -band 0b100
    $Jump = $Number -band 0b1000
    $Reverse = $Number -band 0b10000

    $SecretHandshake = @()
    if ($Wink -eq 0b1) { $SecretHandshake += , "wink" }
    if ($DoubleBlink -eq 0b10) { $SecretHandshake += , "double blink" }
    if ($CloseYourEyes -eq 0b100) { $SecretHandshake += , "close your eyes" }
    if ($Jump -eq 0b1000) { $SecretHandshake += , "jump" }
    if ($Reverse -eq 0b10000 -and $SecretHandshake.Count -gt 0) {
        $ReversedSecretHandshake = ($SecretHandshake.Count - 1)..0 | Foreach-Object { $SecretHandshake[$_] }
        return $ReversedSecretHandshake
    }
    else {
        return $SecretHandshake
    }

    <#
    .SYNOPSIS
    Convert a number between 1 and 31 to a sequence of actions in the secret handshake.

    .DESCRIPTION
    The sequence of actions is chosen by looking at the rightmost five digits of the number once it's been converted to binary.
    Start at the right-most digit and move left.

    The actions for each number place are:
    00001 = wink
    00010 = double blink
    00100 = close your eyes
    01000 = jump
    10000 = Reverse the order of the operations in the secret handshake.

    .PARAMETER Number
    The value to be converted into a sequence of actions.

    .EXAMPLE
    Invoke-SecretHandshake -Number 2
    Returns: @("double blink")
     #>
}
