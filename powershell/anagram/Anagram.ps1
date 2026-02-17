Function Get-StringProfile {
    Param([string]$StringParam)
    # transform string into hashtable dictionary of char counts
    $StringProfile = @{}
    foreach ($C in [char[]]$StringParam) {
        $StringProfile["$C"]++
    }
    $StringProfile
}

Function Compare-Profiles {
    Param([hashtable]$Profile1,[hashtable]$Profile2)
    # True iff both hashtables have identical key+value pairs
    if ($Profile1.Count -ne $Profile2.Count) {
        return $false  # key+value counts differ
    }
    $P1Keys = $Profile1.Keys
    $P2Keys = $Profile2.Keys
    foreach ($K in $P1Keys) {
        if (-not ($K -in $P2Keys)) {
            return $false  # key mismatch
        }
        if ($Profile1["$K"] -ne $Profile2["$K"]) {
            return $false  # value mismatch
        }
    }
    return $true
}

Function Invoke-Anagram() {
    [CmdletBinding()]
    Param(
        [string]$Subject,
        [string[]]$Candidates
    )

    $Result = @()
    $SubjectProfile = Get-StringProfile $Subject
    foreach ($Candidate in $Candidates) {
        if ($Candidate -eq $Subject) { continue }
        $CandidateProfile = Get-StringProfile $Candidate
        if (Compare-Profiles $CandidateProfile $SubjectProfile) {
            $Result += , $Candidate
        }
    }
    Return $Result

    <#
    .SYNOPSIS
    Determine if a word is an anagram of other words in a list.

    .DESCRIPTION
    An anagram is a word formed by rearranging the letters of another word, e.g., spar, formed from rasp.
    Given a word and a list of possible anagrams, find the anagrams in the list.

    .PARAMETER Subject
    The word to check

    .PARAMETER Candidates
    The list of possible anagrams

    .EXAMPLE
    Invoke-Anagram -Subject "listen" -Candidates @("enlists" "google" "inlets" "banana")
    #>
}
