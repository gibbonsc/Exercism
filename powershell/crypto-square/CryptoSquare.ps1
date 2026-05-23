Function Get-SquareRoot {
    # (Leverage a solution of Exercism's square-root exercise)
    [CmdletBinding()]
    Param(
        [int]$Radicand
    )
    $Lb, $Ub = 0, ($Radicand + 1)
    while ($Lb -ne ($Ub - 1)) {
        if (($Lb + $Ub) % 2 -eq 0) { $Candidate = ($Lb + $Ub) / 2 } else { $Candidate = ($Lb + $Ub - 1) / 2 }
        if ($Candidate * $Candidate -le $Radicand) { $Lb = $Candidate } else { $Ub = $Candidate }
    }
    Return $Lb
}

Function Get-CryptoRowsCols {
    [CmdletBinding()]
    Param([int]$Area)
    # helper function: predict dimensions of a crypto-square rectangle
    #   "as square as possible" that has size no smaller than $Area
    $C = 1 + (Get-SquareRoot ($Area - 1))
    $R = ($C * $C - $C -lt $Area) ? $C : $C - 1
    return @($R, $C)
}

Function Invoke-CryptoSquare() {
    [CmdletBinding()]
    Param(
        [string]$PlainText
    )
    $NormalizedPT = $PlainText.ToLower() -replace '[^0-9a-z]',''
    $Size = $NormalizedPT.Length
    if ($Size -eq 0) { return "" }
    $Rows,$Cols = Get-CryptoRowsCols $Size

    # build a pile of $Cols strings
    $Pile = @("") * $Cols;
    # each pile will have $Rows characters
    for ($Row = 0; $Row -lt $Rows; $Row++) {
        for ($Col = 0; $Col -lt $Cols; $Col++) {
            # "transpose" characters into the crypto-square
            $Index = $Row * $Cols + $Col
            if ($Index -ge $Size) {
                # pad short strings with spaces
                $Ch = ' '
            }
            else {
                $Ch = $NormalizedPT.Substring($Index,1)
            }
            $Pile[$Col] += $Ch
        }
    }
    return $Pile -join ' '

    <#
    .SYNOPSIS
    Implement the classic method for composing secret messages called a square code.

    .DESCRIPTION
    Given an English text, output the encoded version of that text.
    First, the input is normalized: the spaces and punctuation are removed from the English text and the message is down-cased.
    Then, the normalized characters are broken into rows.
    These rows can be regarded as forming a rectangle when printed with intervening newlines.

    .PARAMETER PlainText
    The string to be encoded.

    .EXAMPLE
    Invoke-CryptoSquare -PlainText "Exercism"
    Return: "ers xcm ei "
    #>
}
