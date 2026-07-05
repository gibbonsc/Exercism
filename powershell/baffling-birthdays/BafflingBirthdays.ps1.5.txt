Function Invoke-BafflingBirthdays {
    [CmdletBinding()]
    Param(
        [int]$People
    )

    # Perform experiment on five thousand random groups of $People people.
    #   But rather than call Get-RandomBirthdates and Test-SharedBirthday
    #   utility functions, just directly interpolate code used in those
    #   functions.
    $prng = [System.Random]::new()  # .NET object instead of Get-Random cmdlet
    $matchesFound = 0
    for ($i = 0; $i -lt 5000; $i++) {
        $hasMatch = $false
        $collisions = [System.Collections.Generic.HashSet[int]]::new()
        for ($b = 0; $b -lt $People; $b++) {
            $birthDayOfYear = $prng.Next(365)
            if (-not $collisions.Add($birthDayOfYear)) {
                $hasMatch = $true; break
            }
        }
        if ($hasMatch) {
            $matchesFound++
        }
    }
    return $matchesFound / 50.0

    <#
    .SYNOPSIS
    Estimate the birthday paradox's probabilities.

    .DESCRIPTION
    To solve the birthday paradox exercise you need to do these steps:
    - Generate random birthdates.
    - Check if a collection of randomly generated birthdates contains at least two with the same birthday.
    - Estimate the probability that at least two people in a group share the same birthday for different group sizes.

    .PARAMETER People
    Number of people in the group.

    .NOTES
    Consider doing 5000 runs of the test for optimal result for 2% tolerance.

    Reference: https://www2.sjsu.edu/faculty/gerstman/StatPrimer/conf-prop.htm
    shares a formula for sample size n = (1 / d)^2, where d = margin of error.
    d = 2% gives n = 2500, and d = 1% gives n = 10000, so a sample size of
    5000 should accurately estimate the probability and be closer than 2% off.
    #>
}

Function Get-RandomBirthdates {
    [CmdletBinding()]
    Param(
        [int]$People
    )

    do {
        $randomYear = Get-Random -Minimum 1 -Maximum 10000
    } while ([DateTime]::IsLeapYear($randomYear))
    $Result = [DateTime[]]::new($People)
    for ($i = 0; $i -lt $People; $i++) {
        $randomMonth = Get-Random -Minimum 1 -Maximum 13
        $randomDay = Get-Random -Minimum 1 -Maximum (
            1 + [DateTime]::DaysInMonth($randomYear, $randomMonth)
        )
        $Result[$i] = [DateTime]::New($randomYear, $randomMonth, $randomDay)
    }
    return $Result

    <#
    .SYNOPSIS
    Generate a collection of birthdates based on a number of people.

    .PARAMETER People
    Number of birthdates to be generated.
    #>
}

Function Test-SharedBirthday {
    [CmdletBinding()]
    Param(
        [DateTime[]]$Birthdates
    )

    # idea from VicMahase: use .NET Hashset instead of [hashtable]
    $Collisions = [System.Collections.Generic.HashSet[int]]::new()
    foreach ($b in $Birthdates) {
        $dayNumber = $b.DayOfYear
        if ($Collisions.Contains($dayNumber)) {
            return $true
        }
        else {
            [void] $Collisions.Add($dayNumber)
        }
    }
    return $false

    <#
    .SYNOPSIS
    Check if there is a shared birthday in a list of random birthdates.

    .PARAMETER Birthdates
    A collection of random Datetime objects represents.
    #>
}
