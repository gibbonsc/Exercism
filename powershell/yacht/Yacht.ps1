# Score categories. Change the values as you see fit.
Enum Category {
    YACHT           
    ONES            
    TWOS            
    THREES          
    FOURS           
    FIVES           
    SIXES           
    FULL_HOUSE      
    FOUR_OF_A_KIND  
    LITTLE_STRAIGHT 
    BIG_STRAIGHT    
    CHOICE          
}

Function Add-Faces {
    Param(
        [int[]]$Dice,
        [int]$Face
    )
    if ($Face -eq 0) {
        # zero argument adds all dice
        return ($Dice | Measure-Object -Sum).Sum
    }
    else {
        # nonzero argument only adds matching faces
        return ($Dice |
            Where-Object { $_ -eq $Face } |
            Measure-Object -Sum).Sum
    }
}
Function Get-Score() {
    [CmdletBinding()]
    Param(
        [int[]]$Dice,
        [Category]$Category
    )

    switch ($Category) {
        YACHT { 
            $Face = $Dice[0]
            $AllSame = $true
            foreach ($die in $Dice[1..4]) {
                $AllSame = ($die -eq $Face) -and $AllSame
            }
            if ($AllSame) {
                return 50
            }
            else {
                return 0
            }
        }
        ONES { return Add-Faces $Dice 1 }
        TWOS { return Add-Faces $Dice 2 }
        THREES { return Add-Faces $Dice 3 }
        FOURS { return Add-Faces $Dice 4 }
        FIVES { return Add-Faces $Dice 5 }
        SIXES { return Add-Faces $Dice 6 }
        FULL_HOUSE {
            $Groups = $Dice | Group-Object | Sort-Object -Property Count
            if ($Groups.Length -ne 2) {
                return 0
            }
            elseif ($Groups[0].Count -eq 2 -and $Groups[1].Count -eq 3) {
                return Add-Faces $Dice 0
            }
            return 0
        }
        FOUR_OF_A_KIND {
            $Groups = $Dice | Group-Object | Sort-Object -Property Count
            if ($Groups.Length -gt 2) {
                return 0
            }
            elseif ($Groups.Length -eq 1) {
                return 4 * $Dice[0]
            }
            elseif ($Groups[0].Count -eq 1 -and $Groups[1].Count -eq 4) {
                return $Groups[1].Group[3] * 4
            }
            return 0
        }
        LITTLE_STRAIGHT {
            $Ordered = $Dice | Sort-Object
            for ($i=1; $i -lt 6; $i++) {
                if ($Ordered[$i - 1] -ne $i) {
                    return 0
                }
            }
            return 30
        }
        BIG_STRAIGHT {
            $Ordered = $Dice | Sort-Object
            for ($i=2; $i -le 6; $i++) {
                if ($Ordered[$i - 2] -ne $i) {
                    return 0
                }
            }
            return 30
        }
        CHOICE { return Add-Faces $Dice 0 }
    }

    <#
    .SYNOPSIS
    Implement a function to get the score of a yacht game.

    .DESCRIPTION
    Given a list of values for five dice and a category, your solution should return the score of the dice for that category.
    If the dice do not satisfy the requirements of the category your solution should return 0.
    You can assume that five values will always be presented, and the value of each will be between one and six inclusively.
    You should not assume that the dice are ordered.

    .PARAMETER Dice
    An array of 5 integer, each represent a dice value.

    .PARAMETER Category
    An Enum value represent a category in the game of yacht.

    .EXAMPLE
    Get-Score -Dice @(1,2,3,4,5) -Category CHOICE
    Return: 15
    #>
}