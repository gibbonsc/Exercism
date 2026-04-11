enum Allergen {
    eggs = 1
    peanuts = 2
    shellfish = 4
    strawberries = 8
    tomatoes = 16
    chocolate = 32
    pollen = 64
    cats = 128
}
Class Allergies {
    [string[]]$Allergies

    Allergies([int]$Code) {
        $this.Allergies = @()
        for ($i=0; $i -lt 8; ++$i) {
            $BitValue = 1 -shl $i
            if (($Code -band $BitValue) -eq $BitValue) {
                $this.Allergies += , [string][Allergen]$BitValue
            }
        }
    }
    [bool] IsAllergicTo([string]$Name) {
        return $this.Allergies -contains $Name
    }
    [string[]] GetAllergies() {
        return $this.Allergies
    }
}

<#
.SYNOPSIS
    Given a person's allergy score, determine whether or not they're allergic to a given item, and their full list of allergies.

.DESCRIPTION
    Given a positive integer to represent the score of a person's allergies, calculate which alleriges they have from the list:
    - eggs (1)
    - peanuts (2)
    - shellfish (4)
    - strawberries (8)
    - tomatoes (16)
    - chocolate (32)
    - pollen (64)
    - cats (128)
    Your task is to write methods that check if the person is allergic to a specific item, and return a list of allergies that they could have.

.EXAMPLE
    $person = [Allergies]::new(34)
    $person.IsAllergicTo("chocolate")   => True
    $person.IsAllergicTo("cats")        => False
    $person.GetAllergies()              => @("peanuts", "chocolate")
#>
