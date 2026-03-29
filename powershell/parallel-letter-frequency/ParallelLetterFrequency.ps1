Function Get-LetterFrequencies() {
    [CmdletBinding()]
    Param(
        [String[]]$Texts
    )

    # scriptblock to invoke in parallel:
    #   independently produces a hash for one [string]$_
    $CountingThread = {
        $ThisTextHash = @{}
        foreach ($Ch in [Char[]]$_) {
            if ([Char]'A' -le $Ch -and $Ch -le [Char]'Z') {
                $Ch = [Char]([int]$Ch + [int]([Char]'a' - [Char]'A'))
            }
            if (
                ([Char]'a' -le $Ch -and $Ch -le [Char]'z') -or
                ($Ch -gt [Char]"`u{00a0}")
            ) {
                $Key = [String]$Ch
                if ($ThisTextHash.ContainsKey($key)) {
                    $ThisTextHash[$Key]++
                }
                else {
                    $ThisTextHash[$Key] = 1
                }
            }
        }
        $ThisTextHash
    }

    # collect (in parallel) hashes for each string, using the scriptblock
    $TextCounts = $Texts | ForEach-Object -Parallel $CountingThread

    # reduce the collection of hashes to one summative hash
    $Result = @{}
    foreach ($CountHash in $TextCounts) {
        $CountHash.Keys | ForEach-Object {
            if ($Result.ContainsKey($_)) {
                $Result[$_] += $CountHash[$_]
            }
            else {
                $Result[$_] = $CountHash[$_]
            }
        }
    }
    $Result

    <#
    .SYNOPSIS
    Count the frequency of letters in texts using parallel computation.

    .PARAMETER Texts
    An array of strings.
    #>
}
