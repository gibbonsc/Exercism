Function Invoke-Encode() {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline)]
        [string]$Data
    )

    if ([string]::IsNullOrEmpty($Data)){
        return ""
    }
    $acc = ""
    $t = $Data[0]
    $n = 1
    foreach ($i in 1..($Data.Length - 1)) {
        $c = $Data[$i]
        if ($c -ceq $t) {
            $n++
        }
        elseif ($t -ne "`0") {
            $acc += (($n -eq 1) ? ($t) : "$n$t")
            $n = 1
            $t = $c
        }
    }
    $acc += (($n -eq 1) ? ($t) : "$n$t")
    return $acc

    <#
    .SYNOPSIS
    Implement run-length encoding function.

    .DESCRIPTION
    Run-length encoding (RLE) is a simple form of data compression, where runs (consecutive data elements) are replaced by just one data value and count.
    
    For example we can represent the original 53 characters with only 13.
    "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB"  ->  "12WB12W3B24WB"

    .PARAMETER Data
    A string represent the data to be encoded.
    This parameter should accept value from pipeline.

    .EXAMPLE
    Invoke-Encode -Data "EEXEERCIIISM"
    Return: "2EX2ERC3ISM"
    #>
}
Function Invoke-Decode() {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline)]
        [string]$Data
    )
    
    $acc = ""
    $t = ""
    foreach ($c in [char[]]$Data) {
        if ($c -ge [char]'0' -and $c -le [char]'9') {
            $t += $c
        }
        else {
            $n = [int]$t
            $acc += [string]$c * (($n -eq 0) ? 1 : $n)
            $t = ""
        }
    }
    return $acc

    <#
    .SYNOPSIS
    Implement run-length decoding function.

    .DESCRIPTION
    Decoding is the reverse of encoding compression, it turn the compressed data into the original form.
    
    For example we can turn the encoded 13 characters to the original 53.
    "12WB12W3B24WB"   ->   "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB"

    .PARAMETER Data
    A string represent the data to be decoded.
    This parameter should accept value from pipeline.

    .EXAMPLE
    Invoke-Decode -Data "2EX2ERC3ISM"
    Return: "EEXEERCIIISM"
    #>
}