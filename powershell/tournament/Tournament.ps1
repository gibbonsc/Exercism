Function Invoke-Tournament {
    [CmdletBinding()]
    Param(
        [string[]]$Results
    )

    # track team win-loss records in a hashtable
    $Records = @{}
    foreach ($Record in $Results) {
        $AwayTeam, $HomeTeam, $Outcome = $Record -split ';'
        if (-not $Records.ContainsKey($AwayTeam)) {
            $Records[$AwayTeam] = @{W = 0; L = 0; D = 0 }
        }
        if (-not $Records.ContainsKey($HomeTeam)) {
            $Records[$HomeTeam] = @{W = 0; L = 0; D = 0 }
        }
        switch ($Outcome) {
            'draw' {
                $Records[$AwayTeam]['D']++
                $Records[$HomeTeam]['D']++
                break;
            }
            'loss' {
                $Records[$AwayTeam]['L']++
                $Records[$HomeTeam]['W']++
                break;
            }
            'win' {
                $Records[$AwayTeam]['W']++
                $Records[$HomeTeam]['L']++
                break;
            }
        }
    }
    # build a report format
    $Fmt = '{0,-30}'
    for ($i = 1; $i -le 5; $i++) { $Fmt += " | {$i,2}" }

    # sort team names alphabetically,
    #   tally points to determine standings,
    #   and build report rows that follow the format
    $Tallies = @()
    foreach ($Key in ($Records.Keys | Sort-Object)) {
        $W = $Records[$Key]['W']
        $L = $Records[$Key]['L']
        $D = $Records[$Key]['D']
        $MP = $W + $L + $D
        $P = 3 * $W + $D
        $Tallies += [pscustomobject]::new(
            @{ P = $P; R = ($Fmt -f $Key, $MP, $W, $D, $L, $P) }
        )
    }

    # assemble the report ordered by points
    $Return = $Fmt -f 'Team', 'MP', 'W', 'D', 'L', 'P'
    foreach ($Row in ($Tallies | Sort-Object -Descending -Property 'P')) {
        $Return += "`n" + $Row['R']
    }
    return $Return

    <#
    .SYNOPSIS
    Tally the results of a small football competition.

    .DESCRIPTION
    Given an array of string containing which team played against which and what the outcome was, create a tally table.

    .PARAMETER Results
    An array of the string, each line represent a match being played and its outcome.

    .EXAMPLE
    Invoke-Tournament -Results @("Annalyn;Elyses;win")
    
    return:
    @"
    Team                           | MP |  W |  D |  L |  P
    Annalyn                        |  1 |  1 |  0 |  0 |  3
    Elyses                         |  1 |  0 |  0 |  1 |  0
    "@
    #>
}
