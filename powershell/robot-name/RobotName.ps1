Class Robot {
    [String]$Name
    static [Hashtable]$Catalog = @{}

    static [char] PickALetter() {
        return 'A'..'Z' | Get-Random
    }
    static [char] PickADigit() {
        return [char]((0..9 | Get-Random) + [int][char]'0')
    }
    static [string] SuggestName() {
        return "" +
            [Robot]::PickALetter() +
            [Robot]::PickALetter() +
            [Robot]::PickADigit() +
            [Robot]::PickADigit() +
            [Robot]::PickADigit()
    }
    static [string] NewName() {
        do {
            $TryName = [Robot]::SuggestName()
        } while ([Robot]::Catalog.ContainsKey($TryName))
        return $TryName
    }

    Robot() {
        $this.Name = [Robot]::NewName()
        [Robot]::Catalog[$this.Name] = $null
    }

    [void] Reset() {
        [Robot]::Catalog.Remove($this.Name)
        $this.Name = [Robot]::NewName()
        [Robot]::Catalog[$this.Name] = $null
    }
}

<#
.SYNOPSIS
    Manage robot factory settings.

.DESCRIPTION
    Generate a random name for a robot when it is created.
    The name should be in the format of two uppercase letters followed by three digits, such as RX837 or BC811.
    The robot should be able to reset and get a completely new name. (Old name that got reset should not be available for future use)

.EXAMPLE
    $robot = [Robot]::new()
    $robot.Name
    Returns: "EX341"
#>
