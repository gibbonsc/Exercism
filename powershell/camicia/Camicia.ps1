using namespace System.Collections.Generic
using namespace System.Text

enum Status {
    Finished
    Loop
}

class CamiciaResult {
    [Status]$Status
    [int]$Cards
    [int]$Tricks
}

class Camicia {
    [int]$DeckSize
    [Queue[string]]$Pile
    [Queue[string]]$ADeck
    [Queue[string]]$BDeck
    [bool]$ATurn
    [int]$Penalty
    [int]$PlayedCards
    [int]$CapturedTricks
    [Hashset[string]]$Sigs

    [string] GetDeckState() {  # helper to check for loop state
        $Sig1 = ''
        $Sig2 = ''
        if ($this.Aturn) {
            foreach ($Card in $this.ADeck) {
                $Sig1 += ($Card -in @('J','Q','K','A')) ?
                    $Card : "-"
            }
            foreach ($Card in $this.BDeck) {
                $Sig2 += ($Card -in @('J','Q','K','A')) ?
                    $Card : "-"
            }
        }
        else {
            foreach ($Card in $this.BDeck) {
                $Sig1 += ($Card -in @('J','Q','K','A')) ?
                    $Card : "-"
            }
            foreach ($Card in $this.ADeck) {
                $Sig2 += ($Card -in @('J','Q','K','A')) ?
                    $Card : "-"
            }
        }
        return $Sig1 + "," + $Sig2
    }

    Camicia([string[]]$ADeck, [string[]]$BDeck) {
        $this.DeckSize = $ADeck.Count + $BDeck.Count
        $this.Pile = [Queue[string]]::new()
        $this.ADeck = [Queue[string]]::new()
        foreach ($Card in $ADeck) { $this.ADeck.Enqueue($Card) }
        $this.BDeck = [Queue[string]]::new()
        foreach ($Card in $BDeck) { $this.BDeck.Enqueue($Card) }
        $this.ATurn = $true
        $this.PlayedCards = 0
        $this.CapturedTricks = 0
        $this.Sigs = $this.GetDeckState()
    }

    [void] SwapTurn() {  # switch to other player's turn
        $this.ATurn = -not $this.ATurn
    }

    [int] PenaltyValue([string]$Card) {
        $Val = 0
        switch ($Card) {
            "J" { $Val = 1 }
            "Q" { $Val = 2 }
            "K" { $Val = 3 }
            "A" { $Val = 4 }
        }
        return $Val
    }

    [int] PlayOneCard() {
        # return 1, 2, 3, or 4 if a payment card is played,
        #  0 if a number card is played, or
        #  -1 if the player has no more cards to play
        if ($this.ATurn) {
            if ($this.ADeck.Count -eq 0) {
                $P = -1
            }
            else {
                $PlayedCard = $this.ADeck.Dequeue()
                $this.Pile.Enqueue($PlayedCard)
                $P = $this.PenaltyValue($PlayedCard)
                ++$this.PlayedCards
            }
        }
        else {
            if ($this.BDeck.Count -eq 0) {
                $P = -1
            }
            else {
                $PlayedCard = $this.BDeck.Dequeue()
                $this.Pile.Enqueue($PlayedCard)
                $P = $this.PenaltyValue($PlayedCard)
                ++$this.PlayedCards
            }
        }
        return $P
    }

    [void] CollectPile() {
        # deliver pile to bottom of opponent's deck
        ++$this.CapturedTricks
        $PileCount = $this.Pile.Count
        for ($i = 0; $i -lt $PileCount; $i++) {
            if ($this.ATurn) {
                $this.BDeck.Enqueue($this.Pile.Dequeue())
            }
            else {
                $this.ADeck.Enqueue($this.Pile.Dequeue())
            }
        }
    }

    [CamiciaResult] SimulateGame() {
        $APlayedInRound = $false
        $BPlayedInRound = $false
        $Loop = $false
        while ($true) {
            if ($APlayedInRound -and $BPlayedInRound) {
                # new round, check deck signature
                $RoundSig = $this.GetDeckState()
                if ($this.Sigs.Contains($RoundSig)) {
                    $Loop = $true
                    break
                }
                else {
                    $this.Sigs.Add($RoundSig)
                    $APlayedInRound = $false
                    $BPlayedInRound = $false
                }
            }

            # play
            $P = $this.PlayOneCard()
            if ($P -eq -1) {  # no cards to play; game over
                if ($this.Pile.Count -gt 0) {
                    $this.CollectPile()
                }
                break
            }

            if ($this.Penalty -gt 0) {  # paying payment card?
                if ($P -gt 0) {  # played new counter payment card
                    $this.Penalty = $P  # reinitialize penalty counter
                    $this.SwapTurn()
                }
                else {
                    --$this.Penalty  # update penalty counter
                    if ($this.Penalty -eq 0) {  # penalty paid in full
                        $APlayedInRound = $false
                        $BPlayedInRound = $false
                        $this.CollectPile()
                        $this.SwapTurn()
                        # check whether full payment ends game
                        if ($this.ATurn) {
                            if ($this.ADeck.Count -eq $this.DeckSize) {
                                break
                            }
                        }
                        else {
                            if ($this.BDeck.Count -eq $this.DeckSize) {
                                break
                            }
                        }
                    }
                }
            }
            else {  # regular play; not playing penalty
                $this.Penalty = $P
                if ($this.ATurn) {
                    $APlayedInRound = $true
                }
                else {
                    $BPlayedInRound = $true
                }
                $this.SwapTurn()
            }

        }

        $Result = [CamiciaResult]::new()
        if ($Loop) {
            $Result.Status = [Status]::Loop
        }
        else {
            $Result.Status = [Status]::Finished
        }
        $Result.Cards = $this.PlayedCards
        $Result.Tricks = $this.CapturedTricks
        return $Result
    }
}

Function Invoke-Camicia() {
    [CmdletBinding()]
    Param(
        [string[]]$PlayerA,
        [string[]]$PlayerB
    )

    $Game = [Camicia]::new($PlayerA, $PlayerB)
    $R = $Game.SimulateGame()
    return $R

    <#
    .SYNOPSIS
    Simulate a game very similar to the classic card game Camicia.

    .DESCRIPTION
    Given two hands of cards, simulate a game (similar to Camicia) until it ends (or detect if it is in a loop).
    Read instruction for rules and game example.

    .PARAMETER PlayerA
    An array of string(s) represents the first player's cards.

    .PARAMETER PlayerB
    An array of string(s) represents the second player's cards.
    #>
}
