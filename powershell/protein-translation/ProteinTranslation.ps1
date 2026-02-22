Function ConvertFrom-Codon {
    Param([string]$Codon)
    if ($Codon.Length -ne 3) { throw "error: Invalid codon" }
    switch -Regex ($Codon) {
        "^AUG$" { Return "Methionine" }
        "^(UUU|UUC)$" { Return "Phenylalanine" }
        "^(UUA|UUG)$" { Return "Leucine" }
        "^(UCU|UCC|UCA|UCG)$" { Return "Serine" }
        "^(UAU|UAC)$" { Return "Tyrosine" }
        "^(UGU|UGC)$" { Return "Cysteine" }
        "^UGG$" { Return "Tryptophan" }
        "^(UAA|UAG|UGA)$" { Return "STOP" }
    }
    throw "error: Invalid codon"
}

Function Invoke-ProteinTranslation() {
    [CmdletBinding()]
    Param(
        [string]$Strand
    )

    $StrandLength = $Strand.Length
    $CodonCount = $StrandLength / 3
    $Result = @()
    for ($i=0; $i -lt $CodonCount; $i++) {
        if ($i*3+2 -gt $StrandLength) { throw "error: Invalid codon" }
        $Codon = $Strand.Substring($i*3,3)
        $Protein = ConvertFrom-Codon $Codon
        if ($Protein -eq "STOP") { break }
        $Result += , $Protein
    }
    Return $Result
    <#
    .SYNOPSIS
    Translate RNA sequences into proteins.

    .DESCRIPTION
    Take an RNA sequence and convert it into condons and then into the name of the proteins in the form of a list.

    .PARAMETER Strand
    The RNA sequence to translate.

    .EXAMPLE
    Invoke-ProteinTranslation -Strand "AUG"
    #>
}
