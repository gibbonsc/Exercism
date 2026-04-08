Function Get-Answer() {
    [CmdletBinding()]
    Param(
        [string]$Question
    )
    if (-not $Question.StartsWith("What is")) {
        throw "Unknown operation"
    }
    $WordProblem = $Question.Trim("?").Substring(7)
    if ($WordProblem -eq "") {
        throw "Syntax error"
    }
    $Tokens = $WordProblem.Split(" ")
    $TokenCount = $Tokens.Count
    $Index = 1
    $Acc = 0
    $Op = "+"
    while ($Index -lt $TokenCount) {
        # expect to parse a numeric operand
        $Operand = $Tokens[$Index++]
        if ($Operand -notmatch "^(-?)[0-9]+") {
            throw "Syntax error"
        }
        # evaluate operation with operand
        switch ($Op) {
            "+" { $Acc += $Operand; break }
            "-" { $Acc -= $Operand; break }
            "*" { $Acc *= $Operand; break }
            "/" { $Acc /= $Operand; break }
            default { throw "Syntax error" }
        }
        # if there are more tokens, expect to parse an arithmetic operation
        if ($Index -lt $TokenCount ) {
            $Operator = $Tokens[$Index++]
            if ($Operator -eq "plus") {
                $Op = "+"
            }
            elseif ($Operator -eq "minus") {
                $Op = "-"
            }
            elseif ($Index -lt $TokenCount) {
                $Operator += " " + $Tokens[$Index++]
                if ($Operator -eq "multiplied by") {
                    $Op = "*"
                }
                elseif ($Operator -eq "divided by") {
                    $Op = "/"
                }
                else {
                    throw "Syntax error"
                }
            }
            elseif ($Operator -match "^(-?)[0-9]+") {
                throw "Syntax error" # a numeric operand isn't an operator
            }
            else {
                throw "Unknown operation"
            }
            # expect while loop to continue with another token after operation
            if ($Index -ge $TokenCount) {
                throw "Syntax error"
            }
        }
    }
    $Acc

    <#
    .SYNOPSIS
    Parse and evaluate simple math word problems.
    
    .DESCRIPTION
    Implement a function that take in a string represent a math word problem and return the answer in integer.
    Throw error if the question doesn't make sense or doesn't related to math problem.

    .PARAMETER Question
    The string represent the math problem.

    .EXAMPLE
    Get-Answer -Question "What is 1 plus 1?"
    Returns: 2
    #>
}
