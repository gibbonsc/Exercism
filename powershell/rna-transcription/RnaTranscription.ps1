Function Invoke-RnaTranscription() {
    [CmdletBinding()]
    Param(
        [string]$Strand
    )

    $RnaTranscriptionMap = @{A='U'; C='G'; G='C'; T='A'}
    $RnaTranscription = ""
    foreach ($C in [char[]]$Strand) {
        $RnaTranscription += $RnaTranscriptionMap["$C"]
    }
    Return $RnaTranscription
    <#
    .SYNOPSIS
    Transcribe a DNA strand into RNA.

    .DESCRIPTION
    Given a DNA strand, return its RNA complement (per RNA transcription).

    .PARAMETER Strand
    The DNA strand to transcribe.

    .EXAMPLE
    Invoke-RnaTranscription -Strand "A"
    #>
}
