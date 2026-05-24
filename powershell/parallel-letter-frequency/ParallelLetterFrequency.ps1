Function Get-LetterFrequencies() {
    [CmdletBinding()]
    Param(
        [String[]]$Texts
    )

    # scriptblock to invoke in parallel:
    #   independently produces a hash for one [string]$_
    $CountingThread = {
        $ThisTextHash = @{}
        $CPCapA = [int][Char]'A'
        $CPCapZ = [int][Char]'Z'
        $CPLowA = [int][Char]'a'
        $CPLowZ = [int][Char]'z'
        $CPA0 = [int][Char]"`u{00a0}"
        $LowerShift = $CPLowA - $CPCapA
        foreach ($Ch in [Char[]]$_) {
            $CodePoint = [int]$Ch
            if ($CPCapA -le $CodePoint -and $CodePoint -le $CPCapZ) {
                $CodePoint += $LowerShift
                $Ch = [Char]$CodePoint
            }
            if (
                ($CPLowA -le $CodePoint -and $CodePoint -le $CPLowZ) -or
                ($CodePoint -gt $CPA0)
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
