Function Invoke-Encode() {
    [CmdletBinding()]
    Param(
        [string]$Message,
        [int]$Rails
    )

    $Pivot = $Rails - 1
    $Acc = @()  # substring accumulators
    for ($i=0; $i -lt $Rails; $i++) { $Acc += , "" }
    $Rail, $Hop = 0, 1  # rail index, hop incrementer
    foreach ($c in [char[]]$Message) {
        $Acc[$Rail] += $c  # attach character to rail
        $Rail += $Hop  # hop to next rail
        if ($Rail -in @(0, $Pivot)) { $Hop *= -1 }
    }
    return -join $Acc

    <#
    .SYNOPSIS
    Implement encoding for the rail fence cipher.

    .DESCRIPTION
    In the Rail Fence cipher, the message is written downwards on successive "rails" of an imaginary fence, then moving up when we get to the bottom (like a zig-zag).
    Finally the message is then read off in rows.

    .PARAMETER Message
    The message to be encoded.

    .PARAMETER Rails
    The number of rails to be use to construct the rail fence.

    .EXAMPLE
    Invoke-Encode -Message "EXERCISM" -Rails 2
    Returns: "EECSXRIM"
    #>
}

Function Invoke-Decode() {
    [CmdletBinding()]
    Param(
        [string]$Ciphertext,
        [int]$Rails
    )

    # First, extract each rail.
    # Use ceiling function arithmetic to determine rail lengths:
    #   given $Ciphertext length n, let
    #   pivot p = $Rails - 1, denominator d = p * 2.
    #   first rail length is:
    #     ceil(n / d)
    #   if $Rails -ge 3, next is:
    #     ceil((n - 1) / d) + ceil((n - d + 1) / d)
    #   if $Rails -ge 4, next has length:
    #     ceil((n - 2) / d) + ceil((n - d + 2) / d)
    #   and so forth, until last rail length is:
    #     ceil((n - p) / d)
    $RailSubstrings = @()
    $N = $Ciphertext.Length
    $P = $Rails - 1  # pivot
    $C = 0  # ciphertext cursor
    for ($i=0; $i -lt $Rails; $i++) {
        if (0 -eq $i) {  # first rail
            $RailLength = [Math]::Ceiling($N / $P / 2)
        }
        elseif ($P -ne $i) {  # next rails
            $RailLength = [Math]::Ceiling(($N - $I) / $P / 2) +
                [Math]::Ceiling(($N - $P - $P + $I) / $P / 2)
        }
        else {  # last rail
            $RailLength = [Math]::Ceiling(($N - $P) / $P / 2)
        }
        $RailSubstrings += , $Ciphertext.Substring($C, $RailLength)
        $C += $RailLength
    }

    # Hop through rails to recover plaintext
    $Plaintext = ""  # accumulator
    $Cs = @()  # rail cursors
    for ($i=0; $i -lt $Rails; $i++) { $Cs += , 0 }
    $Rail, $Hop = 0, 1  # index, incrementer
    while ($Plaintext.Length -lt $N) {
        $Plaintext += $RailSubstrings[$Rail].Substring($Cs[$Rail]++, 1)
        $Rail += $Hop
        if ($Rail -in @(0, $P)) { $Hop *= -1 }
    }

    return $Plaintext

    <#
    .SYNOPSIS
    Implement decoding for the rail fence cipher.

    .DESCRIPTION

    .PARAMETER CipherText
    The ciphertext to be decoded.

    .PARAMETER Rails
    The number of rails to be use to construct the rail fence.

    .EXAMPLE
    Invoke-Decode -Ciphertext "EECSXRIM" -Rails 2
    Returns: "EXERCISM"
    #>
}